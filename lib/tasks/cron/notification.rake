namespace :cloud_bell do
    namespace :cron do
        desc "Send an email every hour to validate if cron jobs work"
        task send_email: :environment do
            user = User.find_by(email: "dalay@lomax.com.gt")

            notification = CloudBell::Notification.create(
                subject: "test cron",
                body: "This is a test for cron jobs",
                cloud_bell_accounts_id: CloudBell::Account.first.id,
                user: User.first
            )

            CloudBell::NotificationMailer.with({ user: user, notification: notification }).notification.deliver_now
        end
    end
end