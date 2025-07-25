module LesliBell
    class Announcement < ApplicationRecord
        belongs_to :account, class_name: "LesliBell::Account"
        belongs_to :user, class_name: "::Lesli::User"
        has_many :users #, class_name: "::Lesli::User"

        enum :category, {
            :info => 'info',
            :danger => 'danger',
            :warning => 'warning',
            :success => 'success'
        }
    end
end
