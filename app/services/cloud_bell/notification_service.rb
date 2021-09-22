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
        def self.generate(user, subject, role_names:nil, user_receiver_emails:nil, body:nil, url:nil, category:nil)

            if role_names
                notifications = []
                User.joins(:roles).where("roles.name in (?)", role_names).each do |user|
                    notification = user.account.bell.notifications.create({
                        category: category,
                        subject: subject,
                        status: 'created',
                        body: body,
                        user: user,
                        url: url
                    })

                    notifications.append({ id: notification.id })
                end

                return notifications
            elsif user_receiver_emails
                notifications = []
                user_receiver_emails.each do |user_email|
                    user = User.find_by(:email => user_email)
                    next unless user

                    notification = user.account.bell.notifications.create({
                        category: category,
                        subject: subject,
                        status: 'created',
                        body: body,
                        user: user,
                        url: url
                    })

                    notifications.append({ id: notification.id })
                end

                return notifications
            else
                return unless user

                notification = user.account.bell.notifications.create({
                    category: category,
                    subject: subject,
                    status: 'created',
                    body: body,
                    user: user,
                    url: url
                })

                return { id: notification.id }
            end

        end
    end
end
