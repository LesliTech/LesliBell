require "test_helper"

module LesliBell
    class NotificationServiceTest < LesliTesting::ModelTester
        setup do
            @user = lesli_users(:one)
            @other_user = lesli_users(:two)
            @account = lesli_bell_accounts(:one)
            @query = { pagination: { page: 1, perPage: 25 } }
        end

        test "creates a notification for the current user" do
            service = NotificationService.new(@user)

            assert_difference -> { Notification.count }, 1 do
                service.create_for_me(
                    subject: "Export ready",
                    category: :success,
                    channel: :web
                )
            end

            notification = Notification.order(:created_at).last

            assert_equal @user, notification.user
            assert_equal @account, notification.account
            assert_equal "success", notification.category
            assert_equal "web", notification.channel
            assert service.successful?
        end

        test "falls back to info and web for unsupported values" do
            NotificationService.new(@user).create_for_me(
                subject: "Fallback values",
                category: :unknown,
                channel: :unknown
            )

            notification = Notification.order(:created_at).last

            assert_equal "info", notification.category
            assert_equal "web", notification.channel
        end

        test "indexes only unread notifications for the current user" do
            records = NotificationService.new(@user, @query).index

            assert_includes records, lesli_bell_notifications(:unread_one)
            assert_includes records, lesli_bell_notifications(:sent_one)
            assert_includes records, lesli_bell_notifications(:legacy_one)
            refute_includes records, lesli_bell_notifications(:read_one)
            refute_includes records, lesli_bell_notifications(:other_account)
        end

        test "counts unread notifications for the current user" do
            count = NotificationService.new(@user).count

            assert_equal 3, count
        end

        test "marks only the current users notification as read" do
            own_notification = lesli_bell_notifications(:unread_one)
            other_notification = lesli_bell_notifications(:other_account)
            service = NotificationService.new(@user)

            assert_same service, service.read(own_notification.id)
            assert_equal "read", own_notification.reload.status

            service.read(other_notification.id)
            assert_equal "created", other_notification.reload.status
        end

        test "can return all notifications in the current account" do
            records = NotificationService.new(@user, @query).index(false)

            assert_includes records, lesli_bell_notifications(:read_one)
            refute_includes records, lesli_bell_notifications(:other_account)
        end
    end
end
