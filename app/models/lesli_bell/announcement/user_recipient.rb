module LesliBell
    class Announcement::UserRecipient < ActiveRecord::Base
        self.table_name = "lesli_bell_announcement_user_recipients"

        belongs_to :announcement, class_name: "LesliBell::Announcement", inverse_of: :user_recipients
        belongs_to :user, class_name: "Lesli::User"
        validate :recipient_belongs_to_account
        before_destroy -> { announcement.lock! }
        after_destroy -> { announcement.deactivate_without_recipients! }

        private

        def recipient_belongs_to_account
            return unless announcement && user
            return if user.account_id == announcement.account.account_id

            errors.add(:user, :invalid)
        end
    end
end
