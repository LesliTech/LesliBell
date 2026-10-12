require "test_helper"

module LesliBell
    class RoutesTest < ActionDispatch::IntegrationTest
        setup do
            @routes = Engine.routes
        end

        test "routes the engine root to the dashboard" do
            assert_recognizes(
                { controller: "lesli_bell/dashboards", action: "show" },
                "/"
            )
        end

        test "routes the notification feed" do
            assert_recognizes(
                { controller: "lesli_bell/notifications", action: "index" },
                "/notifications"
            )
        end

        test "routes notification updates" do
            assert_recognizes(
                { controller: "lesli_bell/notifications", action: "update", id: "42" },
                { method: :put, path: "/notifications/42" }
            )
        end

        test "routes the announcement entry point" do
            assert_recognizes(
                { controller: "lesli_bell/announcements", action: "index" },
                "/announcements"
            )
        end
    end
end
