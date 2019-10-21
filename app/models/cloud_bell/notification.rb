module CloudBell
    class Notification < ApplicationRecord
        belongs_to :account, class_name: 'CloudBell::Account', foreign_key: 'cloud_bell_accounts_id'
        belongs_to :user, class_name: 'User', foreign_key: 'users_id'
        belongs_to :type, class_name: 'CloudBell::NotificationType', foreign_key: 'cloud_bell_notification_types_id'
    end
end
