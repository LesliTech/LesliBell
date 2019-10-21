module CloudBell
    class NotificationJob < ApplicationJob
        queue_as :default

        def perform(*args)
            Notification.new({
                content: 'content',
                href: 'href',
                read: false,
                cloud_bell_notification_types_id: 1,
                users_id: 1,
                cloud_bell_accounts_id: 1
            }).save!
        end
    end
end
