module LesliBell
    class Notification < ApplicationRecord
        belongs_to :account, class_name: "LesliBell::Account"
        belongs_to :user, class_name: "::Lesli::User"


        enum category: {
            info: "info",
            danger: "danger",
            warning: "warning",
            success: "success"
        }

        enum channel: {
            push: "push",                   # webpush & mobilepush
            email: "email",                 # notification sent by email only
            webpush: "webpush",             # notification for web interface only
            mobilepush: "mobilepush",       # notification for mobile only
            mobiledialog: "mobiledialog",   # open a dialog in the main app screen
        }

        enum status: {
            read: "read",
            sent: "sent",
            created: "created"
        }
    end
end
