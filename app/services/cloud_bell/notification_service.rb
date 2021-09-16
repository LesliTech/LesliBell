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

module CloudBabel
    class NotificationService
        def self.generate(user, subject, role_names:nil, body:nil, url:nil, kind:nil, category:nil)

            if not user or role_names
                notifications = []
                User.joins(:roles).where("roles.name in (?)", role_names).each do |user|
                    notification = user.account.bell.notifications.create({
                        subject: subject,
                        body: body,
                        kind: category || kind,
                        user: user,
                        url: url,
                        sender: sender
                    })

                    notifications.append({ id: notification.id })
                end

                return notifications
            else
                notification = user.account.bell.notifications.create({
                    subject: subject,
                    body: body,
                    kind: category || kind,
                    user: user,
                    url: url,
                    sender: sender
                })

                return { id: notification.id }
            end

        end
    end
end
