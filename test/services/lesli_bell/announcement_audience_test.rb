require "test_helper"

module LesliBell
    class AnnouncementAudienceTest < LesliTesting::ModelTester
        setup do
            @user = lesli_users(:one)
            @other = lesli_users(:two)
            @foreign_account = @other.account
            @other.update!(account: @user.account)
            @role = @user.account.roles.create!(name: "Readers", permission_level: 1, active: true)
        end

        def create_announcement(**attributes)
            service = AnnouncementService.new(@user).create({ name: "Audience", message: "News" }.merge(attributes))
            assert service.successful?, service.errors.inspect
            service.result
        end

        def visible?(announcement, user = @user)
            AnnouncementService.new(user).list.exists?(announcement.id)
        end

        test "general and user audiences are isolated and dismissals stay individual" do
            general = create_announcement
            directed = create_announcement(user_ids: [@user.id, @other.id, @user.id])
            assert visible?(general, @other)
            assert visible?(directed, @other)
            assert_equal 2, directed.user_recipients.count
            AnnouncementService.new(@user).dismiss(directed.id)
            assert_not visible?(directed)
            assert visible?(directed, @other)
            @other.update!(account: @foreign_account)
            assert_not visible?(general, @other)
            assert_not visible?(directed, @other)
        end

        test "roles use current membership and combined matches do not duplicate banners" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            announcement = create_announcement(user_ids: [@user.id], role_ids: [@role.id])
            assert visible?(announcement)
            assert_not visible?(announcement, @other)
            membership = LesliShield::User::Role.create!(user: @other, role: @role)
            assert visible?(announcement, @other)
            LesliShield::User::Role.create!(user: @user, role: @role)
            assert_equal 1, AnnouncementService.new(@user).list.where(id: announcement.id).count
            membership.destroy!
            assert_not visible?(announcement, @other)
            role_only = create_announcement(role_ids: [@role.id])
            assert visible?(role_only)
            @role.destroy!
            assert_not visible?(role_only)
        end

        test "rejects foreign and nonexistent recipients atomically" do
            foreign_role = @foreign_account.roles.create!(name: "Foreign", permission_level: 1, active: true)
            @other.update!(account: @foreign_account)
            [{ user_ids: [@other.id] }, { role_ids: [foreign_role.id] }, { user_ids: [0] }, { role_ids: [0] }].each do |attributes|
                assert_no_difference("Announcement.count") do
                    service = AnnouncementService.new(@user).create({ name: "Invalid", message: "News" }.merge(attributes))
                    assert_not service.successful?
                    assert service.result.errors.any?
                end
            end
            announcement = create_announcement(user_ids: [@user.id])
            service = AnnouncementService.new(@user).show(announcement.id).update(name: "Changed", user_ids: [@other.id])
            assert_not service.successful?
            assert_equal "Audience", announcement.reload.name
            assert_equal [@user.id], announcement.user_recipients.pluck(:user_id)
        end

        test "omitted selections are preserved and replacements do not deactivate" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            announcement = create_announcement(user_ids: [@user.id], role_ids: [@role.id])
            service = AnnouncementService.new(@user).show(announcement.id).update(name: "Edited")
            assert service.successful?
            assert_equal [@user.id], announcement.user_recipients.pluck(:user_id)
            service = AnnouncementService.new(@user).show(announcement.id).update(user_ids: [@other.id], role_ids: [])
            assert service.successful?
            assert_equal [@other.id], announcement.user_recipients.pluck(:user_id)
            assert_empty announcement.role_recipients.reload
            assert announcement.reload.active?
            assert_not visible?(announcement)
            assert visible?(announcement, @other)
        end

        test "replacing users with roles preserves publication" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            announcement = create_announcement(user_ids: [@user.id])
            service = AnnouncementService.new(@user).show(announcement.id).update(user_ids: [], role_ids: [@role.id])
            assert service.successful?
            assert announcement.reload.active?
            assert_empty announcement.user_recipients
            assert_equal [@role.id], announcement.role_ids
        end

        test "clearing the final recipient disables the specific announcement" do
            announcement = create_announcement(user_ids: [@user.id])
            service = AnnouncementService.new(@user).show(announcement.id).update(user_ids: [])
            assert service.successful?
            assert_not announcement.reload.active?
            assert announcement.audience_specific?
            assert_empty announcement.user_recipients
            assert_not visible?(announcement, @other)
            service = AnnouncementService.new(@user).show(announcement.id).update(active: true, audience: "specific")
            assert_not service.successful?
            # Publishing to everyone requires an explicit audience change.
            service = AnnouncementService.new(@user).show(announcement.id).update(active: true, audience: "account")
            assert service.successful?
            assert visible?(announcement, @other)
        end

        test "destroying the final recipient directly also disables the announcement" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            announcement = create_announcement(user_ids: [@user.id], role_ids: [@role.id])
            announcement.user_recipients.first.destroy!
            assert announcement.reload.active?
            announcement.role_recipients.first.destroy!
            assert_not announcement.reload.active?
            assert announcement.audience_specific?
        end

        test "specific selection is required and submitted values survive errors" do
            service = AnnouncementService.new(@user).create(name: "Invalid", message: "News", audience: "specific", user_ids: [""])
            assert_not service.successful?
            service = AnnouncementService.new(@user).create(name: "", message: "News", user_ids: [@user.id])
            assert_not service.successful?
            assert_equal [@user.id.to_s], service.result.user_ids
            assert service.result.audience_specific?
        end

        test "recipient insertion failure rolls back the announcement and prior recipients" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            announcement = create_announcement(user_ids: [@user.id])
            service = AnnouncementService.new(@user).show(announcement.id)
            failure = -> { errors.add(:base, "Insertion failed") }
            Announcement::RoleRecipient.set_callback(:validate, :before, failure)
            service.update(name: "Changed", user_ids: [@other.id], role_ids: [@role.id])
            assert_not service.successful?
            assert_equal "Audience", announcement.reload.name
            assert_equal [@user.id], announcement.user_recipients.pluck(:user_id)
            assert_empty announcement.role_recipients
        ensure
            Announcement::RoleRecipient.skip_callback(:validate, :before, failure) if failure
        end

        test "general and user audiences work without Shield but roles are rejected" do
            shield = Object.send(:remove_const, :LesliShield) if defined?(LesliShield)
            general = create_announcement
            directed = create_announcement(user_ids: [@user.id])
            assert visible?(general, @other)
            assert visible?(directed)
            assert_not visible?(directed, @other)
            service = AnnouncementService.new(@user).create(name: "Roles", message: "News", role_ids: [@role.id])
            assert_not service.successful?
        ensure
            Object.const_set(:LesliShield, shield) if shield
        end

        test "recipient constraints reject duplicates and cross account model writes" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            announcement = create_announcement(user_ids: [@user.id], role_ids: [@role.id])
            assert_raises(ActiveRecord::RecordNotUnique) { announcement.user_recipients.create!(user: @user) }
            assert_raises(ActiveRecord::RecordNotUnique) { announcement.role_recipients.create!(role: @role) }
            @other.update!(account: @foreign_account)
            assert_not announcement.user_recipients.build(user: @other).valid?
        end
    end
end
