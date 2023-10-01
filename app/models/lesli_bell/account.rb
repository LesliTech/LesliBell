module LesliBell
    class Account < ApplicationRecord
        belongs_to :account, class_name: "::Lesli::Account"
        has_many :notifications
        has_many :announcements
    end
end
