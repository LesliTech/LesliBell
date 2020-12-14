module CloudBell
    class Account < ApplicationRecord
        belongs_to :account, class_name: "::Account", foreign_key: "id"
        has_many :notifications, foreign_key: "cloud_bell_accounts_id"
        has_many :announcements, foreign_key: "cloud_bell_accounts_id"
    end
end
