require "test_helper"

module LesliBell
    class AnnouncementSeedsTest < LesliTesting::ModelTester
        def load_announcements
            load Engine.root.join("db", "seed", "announcements.rb")
        end

        test "seeds use the current API and preserve existing announcements on repeated runs" do
            load_announcements
            author = Lesli::User.first!
            announcement = author.account.bell.announcements.find_by!(name: "instance-created")
            assert_equal author, announcement.user
            assert announcement.audience_account?
            assert announcement.active?
            assert announcement.can_be_closed?
            assert_empty announcement.user_recipients
            assert_empty announcement.role_recipients
            announcement.update!(message: "Customized welcome", active: false)
            AnnouncementService.new(author).dismiss(announcement.id)
            assert_no_difference("Announcement.count") { load_announcements }
            assert_equal "Customized welcome", announcement.reload.message
            assert_not announcement.active?
            assert_equal 1, announcement.dismissals.count
            announcement.destroy!
            assert_no_difference("Announcement.with_deleted.count") { load_announcements }
        end

        test "seeds expose validation failures instead of silently skipping them" do
            failure = -> { errors.add(:base, "Invalid seed") }
            Announcement.set_callback(:validate, :before, failure)
            assert_raises(ActiveRecord::RecordInvalid) { load_announcements }
        ensure
            Announcement.skip_callback(:validate, :before, failure)
        end
    end
end
