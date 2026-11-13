module LesliBell
    class AnnouncementService < Lesli::ApplicationLesliService

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
            current_user.account.bell.announcements
                .order(:created_at, :id)
                .page(query[:pagination][:page])
                .per(query[:pagination][:perPage])
        end

        def create(announcements_params)

            unless Announcement.categories.key?(announcements_params[:category])
                announcements_params[:category] = Announcement.new.category
            end

            announcements_params[:user_id] = current_user.id

            announcement = current_user.account.bell.announcements.create!(announcements_params)

            self.resource = announcement

            self
        end 

        def dismiss(id)
            announcement = current_user.account.bell.announcements.find(id)
            unless announcement.can_be_closed?
                announcement.errors.add(:base, I18n.t("lesli_bell.announcements.cannot_dismiss"))
                raise ActiveRecord::RecordInvalid.new(announcement)
            end

            # The unique index makes repeated requests return the same dismissal,
            # preserving the original created_at even when requests overlap.
            self.resource = announcement.dismissals.create_or_find_by!(user: current_user)
            self
        end
    end
end
