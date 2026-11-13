module LesliBell
    # Dismissals are permanent records; do not inherit the soft-delete behavior.
    class Announcement::User < ActiveRecord::Base
        self.table_name = "lesli_bell_announcement_users"

        belongs_to :announcement, class_name: "LesliBell::Announcement", inverse_of: :dismissals
        belongs_to :user, class_name: "::Lesli::User"
    end
end
