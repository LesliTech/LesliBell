module LesliBell
    class AnnouncementService < Lesli::ApplicationLesliService

        def list 

            # NOTE: the query must be created in this specific order, if not ActiveRecord creates weird sql
            # due the OR statement we are usign to get the announcements with a path
            
            # Get all the announcements for the current user
            announcements = current_user.account.bell.announcements

            # joining to the announcement_users table, to see if the users already mark the announcement as read
            announcements = announcements.left_joins(:users)

            # get the announcements without a specific path (global announcements)
            announcements = announcements.where(path: nil)

            # get the announcements with a specific path (to show only in a specific page)
            #announcements = announcements.or(Announcement.where("path = ?", filters[:base_path])) if params.dig(:f, :base_path)

            # get the announcements with a start date greater than or equal to current date and with expiration date less or equal than current date
            # announcements = announcements.where("start_at <= '#{Date.now.end_of_day}' or start_at is NULL")
            # .where("cloud_bell_announcements.end_at >= '#{LC::Date.now.beginning_of_day}' or end_at is NULL")

            # get the announcements that are not marked as read by the user
            announcements = announcements.where(users: { id: nil })

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

        def create(
            announcements_params,
            send_to_role_ids:nil, 
            send_to_user_ids:nil, 
            send_to_user_emails:nil
        )

            users = []

            unless Announcement.categories.key?(announcements_params[:category])
                announcements_params[:category] = :info
            end

            announcements_params[:user_id] = current_user.id

            announcement = current_user.account.bell.announcements.create!(announcements_params)

            self.resource = announcement

            self
        end 

        def read id
            noti = current_user.account.bell.notifications.where(:id => id, :user => current_user)
            noti.update(:status => :read)
            self
        end
    end
end
