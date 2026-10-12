ENV["RAILS_ENV"] = "test"

require "lesli_testing"

LesliTesting.engine("LesliBell", {
    coverage_min_coverage: 60,
    coverage_profile: "engine"
})

require_relative "dummy/config/environment"

ActiveRecord::Migrator.migrations_paths = [ File.expand_path("dummy/db/migrate", __dir__) ]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)

require "rails/test_help"

if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
    fixture_paths = [
        File.expand_path("fixtures", __dir__),
        Lesli::Engine.root.join("test", "fixtures").to_s
    ]

    ActiveSupport::TestCase.fixture_paths = fixture_paths
    ActionDispatch::IntegrationTest.fixture_paths = fixture_paths
    ActiveSupport::TestCase.file_fixture_path = File.join(fixture_paths.first, "files")

    ActiveSupport::TestCase.set_fixture_class(
        lesli_accounts: "Lesli::Account",
        lesli_users: "Lesli::User",
        lesli_bell_accounts: "LesliBell::Account",
        lesli_bell_notifications: "LesliBell::Notification",
        lesli_bell_announcements: "LesliBell::Announcement",
        lesli_bell_announcement_users: "LesliBell::Announcement::User"
    )

    ActiveSupport::TestCase.fixtures :all
end
