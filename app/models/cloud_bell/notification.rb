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
    class Notification < ApplicationLesliRecord
        belongs_to :account, class_name: "CloudBell::Account", foreign_key: "cloud_bell_accounts_id"
        belongs_to :user, class_name: "::User", foreign_key: "users_id"

        after_create :send_notification

        enum category: {
            info: "info",
            success: "success",
            warning: "warning",
            danger: "danger"
        }

        enum sender: {
            web: "web",
            email: "email",
            push: "push"
        }

        enum status: {
            created: "created",
            sent: "sent",
            read: "read"
        }

        def self.index current_user, query
            notifications = current_user.account.bell.notifications
            .order(created_at: :DESC)
            
            # add pagination
            notifications = notifications
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(:updated_at)

            LC::Response.pagination(
                notifications.current_page,
                notifications.total_pages,
                notifications.total_count,
                notifications.length,
                notifications.map do |notification|
                    {
                        id: notification[:id],
                        subject: notification[:subject],
                        body: notification[:body],
                        kind: notification[:kind],
                        url: notification[:url],
                        created_at: LC::Date.distance_to_words(notification[:created_at]),
                        status: notification[:status],
                    }
                end
            )

        end

        def send_notification
            case sender
            when "email"
                NotificationMailer.with({user: user, notification: self}).notification.deliver_later
            when "web"
            when "push"
            end
        end

        def self.count current_user
            current_user.account.bell.notifications.count
        end

    end
end
