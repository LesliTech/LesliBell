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

            # LC::Response.pagination(
            #     notifications.current_page,
            #     notifications.total_pages,
            #     notifications.total_count,
            #     notifications.length,
            #     notifications.map do |notification|
            #         {
            #             id: notification[:id],
            #             url: notification[:url],
            #             body: notification[:body],
            #             subject: notification[:subject],
            #             category: notification[:category],
            #             created_at: LC::Date.distance_to_words(notification[:created_at]),
            #             status: notification[:status],
            #         }
            #     end
            # )

        end

        def create(
            subject, 
            url:nil, 
            body:nil, 
            media:nil,
            payload:nil,
            channel:nil,
            category:nil, 
            user_receiver_id:nil, 
            notification_type:nil, 
            role_receiver_names:nil, 
            user_receiver_emails:nil
        )

            # validate that the notifications has a valid category
            category = 'info' if not ['info', 'danger', 'warning', 'success'].include?(category)

            # set push (web and mobile) notifications as default channel
            channel = 'push' unless channel

            # base notification data
            notification_params = {
                url: url,
                body: body,
                media: media,
                payload: payload,
                channel: channel,
                subject: subject,
                category: category,
                notification_type: notification_type,
                status: 'created',
                user: current_user
            }
        
            # "bulk insert" all the notifications
            notifications = current_user.account.bell.notifications.create([notification_params])

            return { id: notifications.map(&:id) }

        end 
    end
end
