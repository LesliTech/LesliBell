ENV["RAILS_ENV"] = "test"

require "lesli_testing"

LesliTesting.engine("LesliBell", {
    coverage_min_coverage: 60,
    fixtures: {
        classes: {
            lesli_bell_accounts: "LesliBell::Account",
            lesli_bell_notifications: "LesliBell::Notification",
            lesli_bell_announcements: "LesliBell::Announcement",
            lesli_bell_announcement_users: "LesliBell::Announcement::User"
        }
    }
})

require_relative "dummy/config/environment"
require "rails/test_help"
