module CloudBell
    class NotificationJob < ApplicationJob
        queue_as :default
        def perform(user:, subject:, body:nil, href:nil, format:'info')
            Notification.new({
                subject: subject,
                body: body,
                href: href,
                format: format,
                users_id: user.id,
                cloud_bell_notification_deliverer_id: 1,
                cloud_bell_accounts_id: user.account.id
            }).save!
        end
    end
end
