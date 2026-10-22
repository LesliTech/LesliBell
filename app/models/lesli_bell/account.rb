module LesliBell
    class Account < ApplicationRecord
        belongs_to :account,
            class_name: "Lesli::Account",
            inverse_of: :bell
        validates :account_id, uniqueness: true
        has_many :notifications
        has_many :announcements
    end
end
