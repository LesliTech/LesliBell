module LesliBell
    class AnnouncementService < Lesli::ApplicationLesliService
        EDITABLE_ATTRIBUTES = %i[name message category active start_at end_at path url can_be_closed].freeze

        # Banner selection is independent of administrative pagination.
        # Compare both date boundaries against the same instant.
        def list(path: nil)
            now = Time.current
            dismissed_ids = Announcement::User.where(user: current_user).select(:announcement_id)

            current_user.account.bell.announcements
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
            persist(announcement)
        end

        def update(attributes)
            resource.assign_attributes(editable_attributes(attributes))
            persist(resource)
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

        def persist(announcement)
            error(announcement.errors.full_messages.to_sentence) unless announcement.save
            response(announcement)
        end
    end
end
