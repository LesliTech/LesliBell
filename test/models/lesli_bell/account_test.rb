require "test_helper"

module LesliBell
    class AccountTest < LesliTesting::ModelTester
        test "belongs to a Lesli account" do
            reflection = Account.reflect_on_association(:account)

            assert_equal :belongs_to, reflection.macro
            assert_equal Lesli::Account, reflection.klass
        end

        test "owns notifications and announcements" do
            notifications = Account.reflect_on_association(:notifications)
            announcements = Account.reflect_on_association(:announcements)

            assert_equal :has_many, notifications.macro
            assert_equal Notification, notifications.klass
            assert_equal :has_many, announcements.macro
            assert_equal Announcement, announcements.klass
        end
    end
end
