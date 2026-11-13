require "test_helper"

module LesliBell
    class AnnouncementServiceTest < LesliTesting::ModelTester
        setup do
            @user = lesli_users(:one)
            @account = lesli_bell_accounts(:one)
            @query = { pagination: { page: 1, perPage: 25 } }
        end

        test "creates an account scoped announcement" do
            service = AnnouncementService.new(@user)

            assert_difference -> { Announcement.count }, 1 do
                service.create({
                    name: "Release",
                    message: "A new release is available.",
                    category: :success
                })
            end

            announcement = service.result

            assert_equal @user, announcement.user
            assert_equal @account, announcement.account
            assert_equal "success", announcement.category
        end

        test "falls back to info for an unsupported category" do
            service = AnnouncementService.new(@user).create({
                name: "Fallback",
                message: "Unknown category",
                category: :unknown
            })

            assert_equal "info", service.result.category
        end

        test "indexes announcements only from the current account" do
            records = AnnouncementService.new(@user, @query).index

            assert_includes records, lesli_bell_announcements(:visible_global)
            assert_includes records, lesli_bell_announcements(:path_specific)
            refute_includes records, lesli_bell_announcements(:other_account)
        end

        test "lists global announcements not dismissed by the current user" do
            records = AnnouncementService.new(@user, @query).list

            assert_includes records, lesli_bell_announcements(:visible_global)
            refute_includes records, lesli_bell_announcements(:dismissed_global)
            refute_includes records, lesli_bell_announcements(:path_specific)
            refute_includes records, lesli_bell_announcements(:other_account)
        end

        test "dismissing hides the banner only for the authenticated user" do
            announcement = lesli_bell_announcements(:visible_global)
            other_user = lesli_users(:two)
            other_user.update!(account: @user.account)

            service = AnnouncementService.new(@user).dismiss(announcement.id)
            assert_equal @user, service.result.user
            assert_equal announcement, service.result.announcement
            assert service.result.created_at.present?
            refute_includes AnnouncementService.new(@user, @query).list, announcement
            assert_includes AnnouncementService.new(other_user, @query).list, announcement

            other_dismissal = AnnouncementService.new(other_user).dismiss(announcement.id).result
            assert_not_equal service.result.id, other_dismissal.id
            assert_equal 2, announcement.dismissals.count
        end

        test "repeated dismissal preserves the original record and timestamp" do
            announcement = lesli_bell_announcements(:visible_global)
            first = AnnouncementService.new(@user).dismiss(announcement.id).result
            travel 1.hour do
                assert_no_difference("Announcement::User.count") do
                    repeated = AnnouncementService.new(@user).dismiss(announcement.id).result
                    assert_equal first.id, repeated.id
                    assert_equal first.created_at, repeated.created_at
                end
            end
        end

        test "non closable announcements reject dismissal" do
            announcement = lesli_bell_announcements(:visible_global)
            announcement.update!(can_be_closed: false)
            assert_no_difference("Announcement::User.count") do
                exception = assert_raises(ActiveRecord::RecordInvalid) do
                    AnnouncementService.new(@user).dismiss(announcement.id)
                end
                assert exception.record.errors[:base].present?
            end
            assert_includes AnnouncementService.new(@user, @query).list, announcement
        end

        test "foreign missing and deleted announcements cannot be dismissed" do
            announcement = lesli_bell_announcements(:visible_global)
            announcement.destroy!
            ids = [announcement.id, lesli_bell_announcements(:other_account).id, 0]
            assert_no_difference("Announcement::User.count") do
                ids.each do |id|
                    assert_raises(ActiveRecord::RecordNotFound) { AnnouncementService.new(@user).dismiss(id) }
                end
            end
        end
    end
end
