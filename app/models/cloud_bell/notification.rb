module CloudBell
    class Notification < ApplicationRecord
        belongs_to :account, class_name: 'CloudBell::Account', foreign_key: 'cloud_bell_accounts_id'
        belongs_to :user, class_name: 'User', foreign_key: 'users_id'
        belongs_to :notification_deliverer, class_name: 'CloudBell::NotificationDeliverer', foreign_key: 'cloud_bell_notification_deliverers_id', optional: true

        enum format: {
            link: 'link',
            info: 'info',
            danger: 'danger',
            primary: 'primary',
            success: 'success',
            warning: 'warning'
        }

    end
end
