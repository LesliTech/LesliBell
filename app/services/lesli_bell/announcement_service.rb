module LesliBell
    class AnnouncementService < Lesli::ApplicationLesliService
        EDITABLE_ATTRIBUTES = %i[name message category active start_at end_at path url can_be_closed audience].freeze

        # Banner selection is independent of administrative pagination.
        # Compare both date boundaries against the same instant.
        def list(path: nil)
            now = Time.current
            dismissed_ids = Announcement::User.where(user: current_user).select(:announcement_id)

            visible = announcements.where(audience: :account)
            user_matches = Announcement::UserRecipient.where(user_id: current_user.id).select(:announcement_id)
            visible = visible.or(announcements.where(audience: :specific, id: user_matches))
            if defined?(LesliShield)
                memberships = LesliShield::User::Role.where(user: current_user).select(:role_id)
                role_ids = current_user.account.roles.where(id: memberships).select(:id)
                role_matches = Announcement::RoleRecipient.where(role_id: role_ids).select(:announcement_id)
                visible = visible.or(announcements.where(audience: :specific, id: role_matches))
            end

            visible
                .where(active: true, path: [nil, path.presence])
                .where("start_at IS NULL OR start_at <= ?", now)
                .where("end_at IS NULL OR end_at > ?", now)
                .where.not(id: dismissed_ids)
                .order(:created_at, :id)
        end

        def index
            pagination = query.fetch(:pagination, {})
            response(announcements.order(:created_at, :id)
                .page(pagination[:page]).per(pagination[:perPage]))
        end

        def show(id)
            response(announcements.find(id))
        end

        alias_method :find, :show

        def create(attributes)
            announcement = announcements.build(editable_attributes(attributes))
            announcement.user = current_user
            persist(announcement, attributes)
        end

        def update(attributes)
            persist(resource, attributes)
        end

        def destroy
            resource.destroy!
            response(resource)
        end

        def dismiss(id)
            announcement = announcements.find(id)
            unless announcement.can_be_closed?
                announcement.errors.add(:base, I18n.t("lesli_bell.announcements.cannot_dismiss"))
                raise ActiveRecord::RecordInvalid.new(announcement)
            end

            # The unique index makes repeated requests return the same dismissal,
            # preserving the original created_at even when requests overlap.
            self.resource = announcement.dismissals.create_or_find_by!(user: current_user)
            self
        end

        private

        def announcements
            current_user.account.bell.announcements
        end

        # Ownership comes from the authenticated context, including direct service calls.
        def editable_attributes(attributes)
            attributes.to_h.symbolize_keys.slice(*EDITABLE_ATTRIBUTES)
        end

        def persist(announcement, attributes)
            attributes = attributes.to_h.symbolize_keys
            Announcement.transaction do
                # Serialize recipient replacement with other edits and dismissals of recipients.
                announcement.lock! if announcement.persisted?
                announcement.assign_attributes(editable_attributes(attributes))
                assign_audience(announcement, attributes)
                announcement.save!
                # Add both kinds before removing either, including user-to-role replacements.
                add_recipients(announcement.user_recipients, :user_id, announcement.user_ids)
                add_recipients(announcement.role_recipients, :role_id, announcement.role_ids)
                announcement.user_recipients.where.not(user_id: announcement.user_ids).each(&:destroy!)
                announcement.role_recipients.where.not(role_id: announcement.role_ids).each(&:destroy!)
                announcement.clear_audience_selection
            end
            response(announcement)
        rescue ActiveRecord::RecordInvalid => exception
            if exception.record != announcement
                announcement.errors.add(:base, exception.record.errors.full_messages.to_sentence)
            end
            error(announcement.errors.full_messages.to_sentence)
            response(announcement)
        end

        def assign_audience(announcement, attributes)
            [:user_ids, :role_ids].each do |key|
                next unless attributes.key?(key)

                announcement.public_send("#{key}=", Array(attributes[key]).reject(&:blank?).map(&:to_s).uniq)
            end

            has_recipients = announcement.user_ids.any? || announcement.role_ids.any?
            if attributes[:audience].to_s == "account"
                announcement.user_ids = []
                announcement.role_ids = []
            elsif has_recipients && !attributes.key?(:audience)
                announcement.audience = :specific
            elsif announcement.audience_specific? && !has_recipients && !attributes.key?(:audience)
                # An API caller can explicitly empty the audience, but never publish it to everyone.
                announcement.active = false
                announcement.allow_empty_audience = true
            end
        end

        def add_recipients(association, foreign_key, ids)
            existing_ids = association.pluck(foreign_key).map(&:to_s)
            (ids.map(&:to_s) - existing_ids).each do |id|
                association.create!(foreign_key => id)
            end
        end
    end
end
