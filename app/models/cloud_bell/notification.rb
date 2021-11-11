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
            danger: "danger",
            warning: "warning",
            success: "success"

        }

        enum channel: {
            web: "web",         # notification for web interface only
            email: "email",     # notification sent by email only
            mobile: "mobile",   # notification for mobile only
        }

        enum status: {
            read: "read",
            sent: "sent",
            created: "created"
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

            # here I should check settings for prefered notification channels
            ['web', 'mobile'].each do |channel|

                if channel == "email"
                    NotificationMailer.with({ user: user, notification: self }).notification.deliver_later
                    next
                end

                if channel == "web"
                    begin

                        wss_id = "notifications_#{ user.id }"

                        if Rails.application.config.lesli_settings["security"]["enable_websockets"]

                            broadcast_server = 'https://lesli.raven.dev.gt' # production hots
                            broadcast_server = 'http://localhost:8080'      # development

                            Faraday.post("#{broadcast_server}/api/wss/channel/#{ wss_id }/message", {
                                id: self.id,
                                subject: self.subject,
                                category: self.category || 'info',
                                body: self.body || 'info',
                                url: self.url || 'info',
                                created_at_date: LC::Date2.new(self.created_at).date_time
                            })

                        end

                    rescue => exception
                        Honeybadger.notify(exception)
                    end
                    next
                end

                if channel == "mobile"
                    begin

                        Courier::One::Firebase::Notification.create(user, {
                            user: user,
                            url: self.url,
                            body: self.body,
                            media: self.media,
                            subject: self.subject,
                            payload: self.payload,
                            category: self.category,
                            created_at: self.created_at,
                            type: self.notification_type,
                        })

                    rescue => exception
                        Honeybadger.notify(exception)
                    end
                    next
                end

            end

            self.update(status: 'sent')

        end

        def self.count current_user, only_own_notifications=false
            notifications = current_user.account.bell.notifications
            notifications = notifications.where(:user => current_user, :status => ["created", "sent", nil]) if only_own_notifications
            notifications.count
        end

        def self.options
            {
                categories: categories.map { |key, value| {value: key, text: value} },
                channels: channels.map { |key, value| {value: key, text: value} }
            }
        end

    end
end
