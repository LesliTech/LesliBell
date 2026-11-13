module LesliBell
    class AnnouncementService < Lesli::ApplicationLesliService

        def list
            # A dismissal belongs to one reader, not to the entire account.
            dismissed_ids = Announcement::User.where(user: current_user).select(:announcement_id)
            announcements = current_user.account.bell.announcements
                .where(path: nil)
                .where.not(id: dismissed_ids)

            announcements.select(
                :id,
                :name,
                :category,
                :message,
                :can_be_closed,
                :start_at,
                :end_at,
                :path
            ).page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(:start_at)
        end

        def index 

            # work with all notifications
            announcements = current_user.account.bell
            .announcements
            .order(:start_at)

            # add pagination
            announcements
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(:updated_at)
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
