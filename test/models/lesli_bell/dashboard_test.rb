require "test_helper"

module LesliBell
    class DashboardTest < ActiveSupport::TestCase
        test "inherits from the shared dashboard" do
            assert_operator Dashboard, :<, Lesli::Shared::Dashboard
        end

        test "does not register engine-specific components" do
            assert_empty Dashboard::COMPONENTS
        end
    end
end
