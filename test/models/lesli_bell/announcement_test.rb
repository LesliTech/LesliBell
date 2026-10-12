require "test_helper"

module LesliBell
    class AnnouncementTest < LesliTesting::ModelTester
        test "belongs to its engine account and creator" do
            account = Announcement.reflect_on_association(:account)
            user = Announcement.reflect_on_association(:user)

            assert_equal Account, account.klass
            assert_equal Lesli::User, user.klass
        end

        test "defines the supported categories" do
            assert_equal %w[info danger warning success], Announcement.categories.keys
        end

        test "has announcement user associations" do
            reflection = Announcement.reflect_on_association(:users)

            assert_equal :has_many, reflection.macro
            assert_equal Announcement::User, reflection.klass
        end
    end
end
