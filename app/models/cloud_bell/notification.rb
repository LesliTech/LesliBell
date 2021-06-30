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
            web: "web",         # notification for web interface only
            email: "email",     # notification sent by email only
            mobile: "mobile",   # notification for mobile only
            push: "push",       # notification will be showed in all the interfaces
            api: "api"          # notification for api clients only
        }

        enum status: {
            created: "created",
            sent: "sent",
            read: "read"
        }

        def self.index current_user, query, only_own_notifications=false

            notifications = current_user.account.bell.notifications
            .order(created_at: :DESC)

            # work only with notifications that belongs to the user
            notifications = notifications.where(:user => current_user, :status => ["created", "sent", nil]) if only_own_notifications

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

        def self.read(current_user, id)

            # check if it is needed to mark all notifications as read
            if id == "all"

                return current_user.account.bell.notifications
                .where(:user => current_user, :status => ["created", "sent", nil])
                .update_all(:status => "read", :deleted_at => Time.current)

            end

            # mark a specific notification as read
            notification = current_user.account.bell.notifications.find(id)

            # mark notification as read if notification exists
            if !notification.blank?

                notification.update(:status => "read")

                # return notification id that were marked as read
                return notification.id

            end

            # if error, return 0
            return 0

        end

        def send_notification

            if sender == "email"
                NotificationMailer.with({ user: user, notification: self }).notification.deliver_later
                return 
            end

            if sender == "push"
                channel = "notifications_#{ user.id }"
                begin
                    return if !Rails.application.config.lesli_settings["configuration"]["security"]["enable_websockets"]
                    Faraday.post("http://localhost:8080/api/wss/channel/#{ channel }/message", {
                        id: self.id,
                        subject: self.subject,
                        category: self.kind,
                        body: self.body || "",
                        url: self.url || "",
                        created_at_date: LC::Date2.new(self.created_at).date_time
                    })
                rescue
                end
                return 
            end
            
        end

        def self.count current_user, only_own_notifications=false
            notifications = current_user.account.bell.notifications
            notifications = notifications.where(:user => current_user, :status => ["created", "sent", nil]) if only_own_notifications
            notifications.count
        end

        def self.options
            {
                categories: categories.map { |key, value| {value: key, text: value} },
                sender: senders.map { |key, value| {value: key, text: value} }
            }
        end

    end
end
