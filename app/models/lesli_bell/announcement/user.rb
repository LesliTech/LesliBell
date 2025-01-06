module LesliBell
    class Announcement::User < ApplicationRecord
        belongs_to :announcement #, class_name: "CloudBell::Announcement", foreign_key: "cloud_bell_announcements_id", optional: false
        #belongs_to :user, class_name: "Lesli::User", foreign_key: "users_id"
    end
end
