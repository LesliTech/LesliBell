require "test_helper"

module LesliBell
    class AnnouncementBannersTest < ActionController::TestCase
        # Exercise the Core loader with real records and the actual banner partial.
        # Other application-shell dependencies are not needed by this integration.
        class PageController < Lesli::ApplicationLesliController
            skip_before_action :set_locale, :set_customizer, :set_requester
            skip_before_action :authenticate_request, :authorize_request, raise: false
            skip_after_action :log_requests, raise: false
            layout false

            def show
                return head :ok if request.format.json?

                render inline: '<%= render "lesli/partials/application-lesli-turbo" %><%= render "lesli/partials/application-lesli-announcements" %><main id="page-content">Page</main>'
            end

            def other
                show
            end
        end

        tests PageController

        setup do
            @routes = ActionDispatch::Routing::RouteSet.new
            @routes.draw do
                get "reports", to: "lesli_bell/announcement_banners_test/page#show"
                get "other", to: "lesli_bell/announcement_banners_test/page#other"
            end
            user = lesli_users(:one)
            @controller.define_singleton_method(:current_user) { user }
            @global = lesli_bell_announcements(:visible_global)
            @page = lesli_bell_announcements(:path_specific)
            @page.update!(start_at: nil)
        end

        test "renders escaped multiline text links and accessible dismissal controls" do
            @global.update!(message: "<script>alert(1)</script>\nSecond line", url: "/help")
            get :show
            assert_response :success
            assert_equal @global.message, Nokogiri::HTML(response.body).at_css("#announcement-#{@global.id} .lesli-announcements-message").text
            assert_select "script", count: 0
            assert_select "#announcement-#{@global.id} a[href='/help'][data-turbo-frame='_top']", text: I18n.t("lesli.announcements.open_link")
            assert_select "#announcement-#{@global.id} form[method='post'] button[aria-label]"
            assert_select "#announcement-#{@page.id} button", count: 0
            assert_select "#application-lesli-announcements + main#page-content"
            assert_select "[data-turbo-permanent], .lesli-notifications-message", count: 0
            assert_equal true, @controller.instance_variable_get(:@lesli_announcements_enabled)
            assert_select "meta[name='turbo-cache-control'][content='no-cache']"
        end

        test "Turbo Drive page requests replace path specific banners and honor dismissal" do
            @request.headers["Turbo-Visit"] = "true"
            get :show
            assert_select "#announcement-#{@global.id}"
            assert_select "#announcement-#{@page.id}"
            @request.env["PATH_INFO"] = "/other"
            get :other
            assert_equal "/other", request.path
            assert_select "#announcement-#{@global.id}"
            assert_select "#announcement-#{@page.id}", count: 0
            AnnouncementService.new(lesli_users(:one)).dismiss(@global.id)
            @request.env["PATH_INFO"] = "/reports"
            get :show
            assert_select "#announcement-#{@global.id}", count: 0
            assert_select "#announcement-#{@page.id}"
        end

        test "opening pages never creates dismissals" do
            assert_no_difference("Announcement::User.count") do
                2.times { get :show }
                @request.env["PATH_INFO"] = "/other"
                get :other
            end
        end

        test "empty pages retain their content without an announcement region" do
            lesli_users(:one).account.bell.announcements.update_all(active: false)
            get :show
            assert_response :success
            assert_select "#application-lesli-announcements", count: 0
            assert_select "main#page-content", text: "Page"
        end

        test "banner labels are translated in English and Spanish" do
            @global.update!(url: "/help")
            [:en, :es].each do |locale|
                I18n.with_locale(locale) do
                    get :show
                    assert_select "section[aria-label=?]", I18n.t("lesli.announcements.title")
                    assert_select "#announcement-#{@global.id} button[aria-label=?]", I18n.t("lesli.announcements.dismiss")
                    assert_select "#announcement-#{@global.id} a", text: I18n.t("lesli.announcements.open_link")
                end
            end
        end

        test "fragment and JSON requests do not load page banners" do
            @request.headers["Turbo-Frame"] = "ticket-details"
            get :show
            assert_empty @controller.instance_variable_get(:@lesli_announcements)
            @request.headers["Turbo-Frame"] = nil
            get :show, format: :json
            assert_empty @controller.instance_variable_get(:@lesli_announcements)
        end

        test "all categories receive complete semantic color classes and decorative icons" do
            Announcement.categories.keys.each do |category|
                @global.update!(category: category)
                get :show
                assert_select "#announcement-#{@global.id}.is-#{category}"
                assert_select "#announcement-#{@global.id} .material-symbols[aria-hidden='true']", minimum: 1
            end
        end
    end
end
