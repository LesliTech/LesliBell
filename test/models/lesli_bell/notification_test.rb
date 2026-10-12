require "test_helper"

module LesliBell
    class NotificationTest < LesliTesting::ModelTester
        test "belongs to its engine account and recipient" do
            account = Notification.reflect_on_association(:account)
            user = Notification.reflect_on_association(:user)

            assert_equal Account, account.klass
            assert_equal Lesli::User, user.klass
        end

        test "defines the supported categories" do
            assert_equal %w[info danger warning success], Notification.categories.keys
        end

        test "defines the supported delivery channels" do
            assert_equal %w[web push email dialog mobile], Notification.channels.keys
        end

        test "defines the notification lifecycle" do
            assert_equal %w[created sent read], Notification.statuses.keys
        end
    end
end
