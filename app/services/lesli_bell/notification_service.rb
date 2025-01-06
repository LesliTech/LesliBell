module LesliBell
    class NotificationService < Lesli::ApplicationLesliService

        def index only_own_notifications=true

            notifications = []

            # work with all notifications
            notifications = current_user.account.bell
            .notifications
            .order(created_at: :DESC)

            # work only with notifications that belongs to the user
            if only_own_notifications
                notifications = notifications.where(:user => current_user, :status => ["created", "sent", nil]) 
            end

            # add pagination
            notifications = notifications
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(:updated_at)

            return notifications
        end

        def create_for_me notification_params
            self.create(notification_params, send_to_user_ids: [current_user.id])
        end

        def create(
            notification_params,
            send_to_role_ids:nil, 
            send_to_user_ids:nil, 
            send_to_user_emails:nil
        )

            users = []
            notifications = []

            unless Notification.categories.key?(notification_params[:category])
                notification_params[:category] = :info
            end

            unless Notification.channels.key?(notification_params[:channel])
                notification_params[:channel] = :web
            end

            send_to_user_ids.each do |user|
                notifications.push({
                    **notification_params,
                    user_id: user,
                })
            end

            # "bulk insert" all the notifications
            current_user.account.bell.notifications.create!(notifications)

            self.resource = { id: notifications.map{ |n| n[:user_id] } }

            self
        end 

        def read id
            noti = current_user.account.bell.notifications.where(:id => id, :user => current_user)
            noti.update(:status => :read)
            self
        end
    end
end
