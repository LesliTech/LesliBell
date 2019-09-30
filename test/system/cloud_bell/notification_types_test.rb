require "application_system_test_case"

module CloudBell
  class NotificationTypesTest < ApplicationSystemTestCase
    setup do
      @notification_type = cloud_bell_notification_types(:one)
    end

    test "visiting the index" do
      visit notification_types_url
      assert_selector "h1", text: "Notification Types"
    end

    test "creating a Notification type" do
      visit notification_types_url
      click_on "New Notification Type"

      click_on "Create Notification type"

      assert_text "Notification type was successfully created"
      click_on "Back"
    end

    test "updating a Notification type" do
      visit notification_types_url
      click_on "Edit", match: :first

      click_on "Update Notification type"

      assert_text "Notification type was successfully updated"
      click_on "Back"
    end

    test "destroying a Notification type" do
      visit notification_types_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Notification type was successfully destroyed"
    end
  end
end
