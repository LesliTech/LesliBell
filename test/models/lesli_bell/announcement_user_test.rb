require "test_helper"

module LesliBell
    class AnnouncementUserTest < LesliTesting::ModelTester
        test "uses the announcement user table" do
            assert_equal "lesli_bell_announcement_users", Announcement::User.table_name
        end

        test "belongs to an announcement" do
            reflection = Announcement::User.reflect_on_association(:announcement)

            assert_equal :belongs_to, reflection.macro
            assert_equal Announcement, reflection.klass
        end

        test "belongs to a Lesli user" do
            reflection = Announcement::User.reflect_on_association(:user)

            assert_equal :belongs_to, reflection.macro
            assert_equal Lesli::User, reflection.klass
        end
    end
end
