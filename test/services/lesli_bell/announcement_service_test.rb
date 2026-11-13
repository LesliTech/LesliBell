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

        test "direct service calls preserve ownership and return their CRUD result" do
            foreign = lesli_users(:two)
            service = AnnouncementService.new(@user).create(
                name: "Scoped", message: "Message", account_id: foreign.account.bell.id, user_id: foreign.id
            )
            assert service.successful?
            record = service.result
            assert_equal @account, record.account
            assert_equal @user, record.user
            service = AnnouncementService.new(@user).show(record.id)
            service.update(name: "Changed", account_id: foreign.account.bell.id, user_id: foreign.id)
            assert service.successful?
            assert_equal @account, record.reload.account
            assert_equal @user, record.user
            service.destroy
            assert service.result.deleted_at.present?
            assert_raises(ActiveRecord::RecordNotFound) { AnnouncementService.new(@user).show(record.id) }
        end

        test "invalid category returns the submitted record and validation errors" do
            service = AnnouncementService.new(@user).create(name: "Invalid", message: "Message", category: "unknown")
            assert_not service.successful?
            assert_equal "unknown", service.result.category
            assert service.result.errors[:category].present?
            assert_not service.result.persisted?
        end

        test "indexes announcements only from the current account" do
            records = AnnouncementService.new(@user, @query).index.result

            assert_includes records, lesli_bell_announcements(:visible_global)
            assert_includes records, lesli_bell_announcements(:path_specific)
            refute_includes records, lesli_bell_announcements(:other_account)
        end

        test "lists global announcements not dismissed by the current user" do
            records = AnnouncementService.new(@user).list

            assert_includes records, lesli_bell_announcements(:visible_global)
            refute_includes records, lesli_bell_announcements(:dismissed_global)
            refute_includes records, lesli_bell_announcements(:path_specific)
            refute_includes records, lesli_bell_announcements(:other_account)
        end

        test "banner selection uses inclusive start and exclusive end boundaries" do
            travel_to Time.zone.local(2026, 11, 13, 12, 0, 0) do
                now = Time.current
                cases = [
                    [nil, nil, true],
                    [now, nil, true],
                    [now + 1.second, nil, false],
                    [nil, now + 1.second, true],
                    [nil, now, false],
                    [nil, now - 1.second, false],
                    [now - 1.hour, now + 1.hour, true]
                ]
                cases.each do |start_at, end_at, visible|
                    announcement = AnnouncementService.new(@user).create(
                        name: "Scheduled", message: "Maintenance", start_at: start_at, end_at: end_at
                    ).result
                    assert_equal visible, AnnouncementService.new(@user).list.exists?(announcement.id)
                end
            end
        end

        test "banner selection includes global and exact page matches within the account" do
            page = lesli_bell_announcements(:path_specific)
            page.update!(start_at: nil)
            service = AnnouncementService.new(@user)
            assert_includes service.list(path: "/reports"), page
            assert_includes service.list(path: "/reports"), lesli_bell_announcements(:visible_global)
            refute_includes service.list(path: "/reports"), lesli_bell_announcements(:other_account)
            [nil, "", "/reports/1", "/reports/", "/other"].each do |path|
                refute_includes service.list(path: path), page
            end
            page.update!(can_be_closed: true)
            AnnouncementService.new(@user).dismiss(page.id)
            refute_includes service.list(path: "/reports"), page
        end

        test "inactive and deleted announcements do not appear in banners" do
            inactive = lesli_bell_announcements(:visible_global)
            inactive.update!(active: false)
            deleted = lesli_bell_announcements(:path_specific)
            deleted.destroy!
            records = AnnouncementService.new(@user).list(path: "/reports")
            refute_includes records, inactive
            refute_includes records, deleted
            assert_includes AnnouncementService.new(@user, @query).index.result, inactive
        end

        test "banner query includes destinations and ignores administrative pagination" do
            announcement = lesli_bell_announcements(:visible_global)
            announcement.update!(url: "/help")
            query = { pagination: { page: 999, perPage: 1 } }
            service = AnnouncementService.new(@user, query)
            assert_empty service.index.result
            assert_equal "/help", service.list.find(announcement.id).url
            assert service.list.find(announcement.id).active?
        end

        test "banner order uses creation time and ID for ties" do
            first = AnnouncementService.new(@user).create(name: "First", message: "First").result
            second = AnnouncementService.new(@user).create(name: "Second", message: "Second").result
            third = AnnouncementService.new(@user).create(name: "Third", message: "Third").result
            first.update!(created_at: 1.day.ago)
            [second, third].each { |record| record.update!(created_at: first.created_at - 1.day) }
            records = AnnouncementService.new(@user).list.where(id: [first.id, second.id, third.id])
            assert_equal [second.id, third.id, first.id], records.pluck(:id)
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
