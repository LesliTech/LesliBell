module LesliBell
    class Announcement::User < ApplicationRecord
        belongs_to :announcement
        belongs_to :user, class_name: "::Lesli::User"
    end
end
