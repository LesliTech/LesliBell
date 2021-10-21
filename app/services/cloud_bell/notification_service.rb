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

        def self.generate(user, subject, body:nil, url:nil, category:nil, user_receiver_id:nil, role_receiver_names:nil, user_receiver_emails:nil, type:nil, media:nil, payload:nil)
            # validate that the notifications has a valid category
            category = 'info' if not ['info', 'danger', 'warning', 'success'].include?(category)

            # base notification data
            notification_params = {
                url: url,
                body: body,
                type: type,
                media: media,
                payload: payload,
                subject: subject,
                status: 'created',
                category: category,
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
