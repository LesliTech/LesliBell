require 'test_helper'

module CloudBell
  class NotificationDeliverersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @notification_deliverer = cloud_bell_notification_deliverers(:one)
    end

    test "should get index" do
      get notification_deliverers_url
      assert_response :success
    end

    test "should get new" do
      get new_notification_deliverer_url
      assert_response :success
    end

    test "should create notification_deliverer" do
      assert_difference('NotificationDeliverer.count') do
        post notification_deliverers_url, params: { notification_deliverer: {  } }
      end

      assert_redirected_to notification_deliverer_url(NotificationDeliverer.last)
    end

    test "should show notification_deliverer" do
      get notification_deliverer_url(@notification_deliverer)
      assert_response :success
    end

    test "should get edit" do
      get edit_notification_deliverer_url(@notification_deliverer)
      assert_response :success
    end

    test "should update notification_deliverer" do
      patch notification_deliverer_url(@notification_deliverer), params: { notification_deliverer: {  } }
      assert_redirected_to notification_deliverer_url(@notification_deliverer)
    end

    test "should destroy notification_deliverer" do
      assert_difference('NotificationDeliverer.count', -1) do
        delete notification_deliverer_url(@notification_deliverer)
      end

      assert_redirected_to notification_deliverers_url
    end
  end
end
