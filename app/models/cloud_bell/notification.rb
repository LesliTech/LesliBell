module CloudBell
    class Notification < ApplicationRecord
        belongs_to :account, class_name: 'CloudBell::Account', foreign_key: 'cloud_bell_accounts_id'
        belongs_to :user, class_name: 'User', foreign_key: 'users_id'

        enum format: {
            link: 'link',
            info: 'info',
            danger: 'danger',
            primary: 'primary',
            success: 'success',
            warning: 'warning'
        }

        enum sender: {
            web: 'web',
            email: 'email'
        }

    end
end
