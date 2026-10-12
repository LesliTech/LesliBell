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

        test "lists only global announcements without a user association" do
            records = AnnouncementService.new(@user, @query).list

            assert_includes records, lesli_bell_announcements(:visible_global)
            refute_includes records, lesli_bell_announcements(:dismissed_global)
            refute_includes records, lesli_bell_announcements(:path_specific)
            refute_includes records, lesli_bell_announcements(:other_account)
        end
    end
end
