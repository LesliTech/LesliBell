module LesliBell
    class Announcement::RoleRecipient < ActiveRecord::Base
        self.table_name = "lesli_bell_announcement_role_recipients"

        belongs_to :announcement, class_name: "LesliBell::Announcement", inverse_of: :role_recipients
        belongs_to :role, class_name: "Lesli::Role"
        validate :recipient_belongs_to_account
        before_destroy -> { announcement.lock! }
        after_destroy -> { announcement.deactivate_without_recipients! }

        private

        def recipient_belongs_to_account
            return unless announcement && role
            return if role.account_id == announcement.account.account_id

            errors.add(:role, :invalid)
        end
    end
end
