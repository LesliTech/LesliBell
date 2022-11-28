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
    class Notification < CloudObject
        belongs_to :account, class_name: "CloudBell::Account", foreign_key: "cloud_bell_accounts_id"
        belongs_to :user, class_name: "::User", foreign_key: "users_id"

        has_many :activities,   foreign_key: "cloud_bell_notifications_id"
        
        after_create :send_notification

        enum category: {
            info: "info",
            danger: "danger",
            warning: "warning",
            success: "success"
        }

        enum channel: {
            email: "email",                 # notification sent by email only
            webpush: "webpush",             # notification for web interface only
            mobilepush: "mobilepush",       # notification for mobile only
            mobiledialog: "mobiledialog",   # open a dialog in the main app screen
            push: "push",                   # webpush & mobilepush
        }

        enum status: {
            read: "read",
            sent: "sent",
            created: "created"
        }

        def self.index current_user, query, only_own_notifications=true

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

            LC::Response.pagination(
                notifications.current_page,
                notifications.total_pages,
                notifications.total_count,
                notifications.length,
                notifications.map do |notification|
                    {
                        id: notification[:id],
                        url: notification[:url],
                        body: notification[:body],
                        subject: notification[:subject],
                        category: notification[:category],
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
            ['web', 'mobile', 'email'].each do |authorized_channel|

                # if channel is authorized check if channels is included in the senders
                if authorized_channel == 'email'
                    notifications = Notification.where.not(id: self.id)  #Get the notifications except the recently created
                    last_notification = notifications.where(subject: self.subject, url: self.url, users_id: self.users_id, created_at: (Time.now.utc - 1.hour..Time.now.utc)).last  #Get the last notification with the same url and user id as the actual notification and created at about an hour ago
                    # Get the number of notifications sended in the last hour that have not been read
                    number_notifications = notifications.where(subject: self.subject, url: self.url, users_id: self.users_id, status:"sent", created_at: (Time.now.utc - 1.hour..Time.now.utc)).count 

                    # If the last notification was sent more than an hour ago, sent an email
                    if last_notification.nil?
                        NotificationService.send_email(user, self, number_notifications) if ['email'].include?(self.channel)
                    end
                end 

                # if channel is authorized check if channels is included in the senders
                if authorized_channel == 'web'
                    NotificationService.send_webpush(user, self) if ['webpush','push'].include?(self.channel)
                end 

                # if channel is authorized check if channels is included in the senders
                if authorized_channel == 'mobile'
                    NotificationService.send_mobilepush(user, self) if ['mobilepush', 'push'].include?(self.channel)
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
