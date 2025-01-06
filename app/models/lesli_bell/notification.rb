module LesliBell
    class Notification < ApplicationRecord
        belongs_to :account, class_name: "LesliBell::Account"
        belongs_to :user, class_name: "::Lesli::User"

        enum category: {
            :info => 'info',
            :danger => 'danger',
            :warning => 'warning',
            :success => 'success'
        }

        enum channel: {
            :web    => 'web',       # notification for web interface only
            :push   => 'push',      # webpush & mobilepush
            :email  => 'email',     # notification sent by email only
            :dialog => 'dialog',    # open a dialog in the main app screen
            :mobile => 'mobile'     # notification for mobile only
        }

        enum status: {
            :created => 'created',
            :sent => 'sent',
            :read => 'read'
        }
    end
end
