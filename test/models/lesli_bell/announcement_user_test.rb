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

        test "requires both references and does not use soft deletion" do
            dismissal = Announcement::User.new
            assert_not dismissal.valid?
            assert dismissal.errors[:announcement].present?
            assert dismissal.errors[:user].present?
            assert_not Announcement::User.column_names.include?("deleted_at")
            [:announcement_id, :user_id].each do |column|
                assert_not Announcement::User.columns_hash.fetch(column.to_s).null
            end
        end

        test "database prevents duplicate dismissals for one user" do
            dismissal = lesli_bell_announcement_users(:dismissed_by_user_one)
            assert_raises(ActiveRecord::RecordNotUnique) do
                Announcement::User.transaction(requires_new: true) do
                    Announcement::User.create!(announcement: dismissal.announcement, user: dismissal.user)
                end
            end
        end
    end
end
