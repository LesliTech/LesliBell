require "test_helper"

module LesliBell
    class AnnouncementConstraintsTest < LesliTesting::ModelTester
        test "announcement required columns are enforced by the database" do
            record = lesli_bell_announcements(:visible_global)
            %i[name message category audience active can_be_closed account_id user_id].each do |column|
                assert_raises(ActiveRecord::NotNullViolation, column.to_s) do
                    Announcement.transaction(requires_new: true) do
                        Announcement.where(id: record.id).update_all(column => nil)
                    end
                end
            end
        end

        test "recipient and dismissal references and uniqueness are enforced without validations" do
            announcement = lesli_bell_announcements(:visible_global)
            user = lesli_users(:one)
            role = user.account.roles.create!(name: "Constraint readers", permission_level: 1, active: true)
            [[Announcement::User, :user_id, user.id],
             [Announcement::UserRecipient, :user_id, user.id],
             [Announcement::RoleRecipient, :role_id, role.id]].each do |model, foreign_key, id|
                attributes = { announcement_id: announcement.id, foreign_key => id }
                model.insert_all!([attributes])
                assert_database_error(ActiveRecord::RecordNotUnique) { model.insert_all!([attributes]) }
                [:announcement_id, foreign_key].each do |column|
                    assert_database_error(ActiveRecord::NotNullViolation) do
                        model.insert_all!([attributes.merge(column => nil)])
                    end
                    assert_database_error(ActiveRecord::InvalidForeignKey) do
                        model.insert_all!([attributes.merge(column => -1)])
                    end
                end
            end
        end

        private

        # PostgreSQL needs a savepoint after each deliberately rejected statement.
        def assert_database_error(error, &block)
            assert_raises(error) { Announcement.transaction(requires_new: true, &block) }
        end
    end
end
