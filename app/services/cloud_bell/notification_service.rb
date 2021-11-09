=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

module CloudBell
    class NotificationService

        def self.send_email user, notification
            NotificationMailer.with({ user: user, notification: notification }).notification.deliver_later
        end

        def self.send_webpush user, notification

            message = {
                subject: notification[:subject],
                body: notification[:body],
                url: notification[:url],
                #icon: "http://example.com/icon.pn",
                #tag: "lesli-driver"
            }

            User::Webpush.all.each do |sub|
                begin
                    result = Webpush.payload_send(
                        endpoint: sub[:endpoint],
                        message: JSON.generate(message),
                        p256dh: sub[:p256dh_key],
                        auth: sub[:auth_key],
                        ttl: 600, # optional, ttl in seconds, defaults to 2419200 (4 weeks)
                        urgency: 'normal', # optional, it can be very-low, low, normal, high, defaults to normal
                        vapid: {
                            public_key: Rails.application.credentials.dig(:services, :vapid, :public_key),
                            private_key: Rails.application.credentials.dig(:services, :vapid, :private_key)
                        }
                    )
                rescue => exception 
                    # if error delete subscription from database
                    sub.destroy
                    #sub.destroy_fully!
                end
            end
        end

        def self.send_mobilepush user, notification
            Courier::One::Firebase::Notification.create(user, {
                user: user,
                url: notification.url,
                body: notification.body,
                media: notification.media,
                subject: notification.subject,
                payload: notification.payload,
                category: notification.category,
                created_at: notification.created_at,
                type: notification.notification_type,
            })
        end

        def self.generate(
            user, 
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
            }

            # notifications to create
            notifications = []

            # create notifications for an specific user (diferent of current_user)
            if user_receiver_id

                user = ::User.find_by_id(user_receiver_id)

                return { id: 0 } if user.blank?

                notifications.push({
                    **notification_params,
                    user: user,
                })

            end

            # create notifications for users with specific emails
            if user_receiver_emails

                User.where(:email => user_receiver_emails).select(:id).each do |user|
                    notifications.push({
                        **notification_params,
                        users_id: user[:id],
                    })
                end

            end

            # create notifications for users that have specific role names
            if role_receiver_names

                User.joins(:roles).where("roles.name in (?)", role_receiver_names).each do |user|
                    notifications.push({
                        **notification_params,
                        users_id: user[:id],
                    })
                end

            end

            # if no notifications for specific users, create notification for the current_user
            if notifications.empty?
                notifications.push({
                    **notification_params,
                    user: user,
                })
            end

            # "bulk insert" all the notifications
            notifications = user.account.bell.notifications.create(notifications)

            return { id: notifications.map(&:id) }

        end
    end
end
