require "application_system_test_case"

module CloudBell
  class NotificationDeliverersTest < ApplicationSystemTestCase
    setup do
      @notification_deliverer = cloud_bell_notification_deliverers(:one)
    end

    test "visiting the index" do
      visit notification_deliverers_url
      assert_selector "h1", text: "Notification Deliverers"
    end

    test "creating a Notification deliverer" do
      visit notification_deliverers_url
      click_on "New Notification Deliverer"

      click_on "Create Notification deliverer"

      assert_text "Notification deliverer was successfully created"
      click_on "Back"
    end

    test "updating a Notification deliverer" do
      visit notification_deliverers_url
      click_on "Edit", match: :first

      click_on "Update Notification deliverer"

      assert_text "Notification deliverer was successfully updated"
      click_on "Back"
    end

    test "destroying a Notification deliverer" do
      visit notification_deliverers_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Notification deliverer was successfully destroyed"
    end
  end
end
