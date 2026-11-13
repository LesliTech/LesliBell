require "test_helper"

module LesliBell
    class AnnouncementsControllerTest < ActionController::TestCase
        tests AnnouncementsController

        setup do
            @routes = Engine.routes
            @announcement = lesli_bell_announcements(:visible_global)
            @user = lesli_users(:one)
            @allowed = true
            test = self
            @user.define_singleton_method(:has_privileges_for?) { |*| test.instance_variable_get(:@allowed) }
            @user.define_singleton_method(:roles) { [] }
            user = @user
            @controller.define_singleton_method(:current_user) { user }
            @controller.class.helper_method :current_user
            @controller.define_singleton_method(:authenticate_request) { true }
            @controller.define_singleton_method(:log_requests) { true }
            @controller.define_singleton_method(:log) { |*| true }
            @controller.define_singleton_method(:_layout) { |*| false }
        end

        test "audience forms retain selections and show only account recipients" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            role = @user.account.roles.create!(name: "Readers", permission_level: 1, active: true)
            get :new
            assert_select "select[name='announcement[audience]']"
            assert_select "select[name='announcement[user_ids][]'][multiple]" do
                assert_select "option[value=?]", @user.id.to_s
                assert_select "option[value=?]", lesli_users(:two).id.to_s, count: 0
            end
            assert_select "select[name='announcement[role_ids][]'][multiple] option[value=?]", role.id.to_s
            post :create, params: { announcement: {
                name: "", message: "Retain", audience: "specific", user_ids: [@user.id], role_ids: [role.id]
            } }, format: :turbo_stream
            assert_response :unprocessable_content
            assert_select "option[value='specific'][selected]"
            assert_select "select[name='announcement[user_ids][]'] option[selected][value=?]", @user.id.to_s
            assert_select "select[name='announcement[role_ids][]'] option[selected][value=?]", role.id.to_s
            post :create, params: { announcement: {
                name: "Directed", message: "News", audience: "specific", user_ids: [@user.id], role_ids: [role.id]
            } }, format: :json
            assert_response :created
            record = Announcement.find(response.parsed_body.fetch("id"))
            assert_equal [@user.id], record.user_ids
            assert_equal [role.id], record.role_ids
            get :show, params: { id: record.id }, format: :html
            assert_response :success
            assert_includes response.body, @user.email
            assert_includes response.body, role.name
        end

        test "user selector is available and role selector follows Shield availability" do
            get :new
            assert_response :success
            assert_select "select[name='announcement[user_ids][]'] option[value=?]", @user.id.to_s
            assert_select "select[name='announcement[role_ids][]']", count: defined?(LesliShield) ? 1 : 0
        end

        test "specific empty audience returns a translated validation error" do
            [:en, :es].each do |locale|
                I18n.with_locale(locale) do
                    post :create, params: { locale: locale, announcement: {
                        name: "Empty", message: "News", audience: "specific", user_ids: [""], role_ids: [""]
                    } }, format: :json
                    assert_response :unprocessable_content
                    assert_includes response.parsed_body.fetch("errors").fetch("base"), I18n.t("lesli_bell.announcements.audience_required")
                end
            end
        end

        test "lists scoped records with pagination and renders LesliView forms" do
            get :index
            assert_response :success
            assert_select "table"
            assert_select "a[href=?]", announcement_path(@announcement)
            assert_select "a[href=?]", announcement_path(lesli_bell_announcements(:other_account)), count: 0
            get :index, params: { perPage: 1 }, format: :json
            assert_equal 1, response.parsed_body.fetch("records").size
            assert_equal 3, response.parsed_body.dig("pagination", "total")
            get :new, format: :html
            assert_response :success
            assert_select "form[data-turbo-frame='_top']"
            assert_select "textarea[name='announcement[message]']"
            assert_select "input[type='datetime-local']", count: 2
            assert_select "input[name='announcement[account_id]']", count: 0
        end

        test "creates and updates with server owned account and author" do
            foreign = lesli_users(:two)
            post :create, params: { announcement: { name: "New", message: "Welcome", user_id: foreign.id, account_id: foreign.account.bell.id } }, format: :json
            assert_response :created
            record = Announcement.find(response.parsed_body.fetch("id"))
            assert_equal @user.id, record.user_id
            assert_equal @user.account.bell.id, record.account_id
            patch :update, params: { id: record.id, announcement: { name: "Changed", active: false, user_id: foreign.id, account_id: foreign.account.bell.id } }, format: :json
            assert_response :success
            assert_equal "Changed", record.reload.name
            assert_not record.active?
            assert_equal @user.id, record.user_id
            assert_equal @user.account.bell.id, record.account_id
        end

        test "HTML and Turbo success redirect while validation preserves content" do
            post :create, params: { announcement: { name: "New", message: "Welcome" } }, format: :html
            assert_response :see_other
            patch :update, params: { id: @announcement.id, announcement: { name: "Changed" } }, format: :turbo_stream
            assert_response :see_other
            [:html, :turbo_stream].each do |format|
                patch :update, params: { id: @announcement.id, announcement: { name: "Retain me", message: "", url: "/help" } }, format: format
                assert_response :unprocessable_content
                assert_select "input[name='announcement[name]'][value='Retain me']"
                assert_select "input[name='announcement[url]'][value='/help']"
                assert_select "[role='alert']"
                assert_select "turbo-stream[target='announcement-form']" if format == :turbo_stream
                assert_equal "Changed", @announcement.reload.name
            end
            post :create, params: { announcement: { name: "Invalid", message: "" } }, format: :json
            assert_response :unprocessable_content
            assert response.parsed_body.fetch("errors").key?("message")
        end

        test "show escapes message content and delete is soft" do
            @announcement.update!(message: "<script>alert(1)</script>")
            get :show, params: { id: @announcement.id }
            assert_response :success
            assert_select "script", count: 0
            assert_includes response.body, "&lt;script&gt;"
            delete :destroy, params: { id: @announcement.id }, format: :json
            assert_response :success
            assert_not Announcement.exists?(@announcement.id)
            assert Announcement.with_deleted.find(@announcement.id).deleted_at.present?
        end

        test "foreign and deleted records are inaccessible to every member operation" do
            @announcement.destroy!
            [lesli_bell_announcements(:other_account).id, @announcement.id, 0].each do |id|
                get :show, params: { id: id }, format: :json
                assert_response :not_found
                get :edit, params: { id: id }, format: :html
                assert_response :not_found
                patch :update, params: { id: id, announcement: { name: "No" } }, format: :json
                assert_response :not_found
                post :dismiss, params: { id: id }, format: :json
                assert_response :not_found
                delete :destroy, params: { id: id }, format: :json
                assert_response :not_found
            end
        end

        test "dismissal supports Turbo JSON and HTML and rejects non closable records" do
            post :dismiss, params: { id: @announcement.id }, format: :turbo_stream
            assert_response :success
            assert_select "turbo-stream[action='remove'][target='announcement-#{@announcement.id}']"
            post :dismiss, params: { id: @announcement.id }, format: :json
            assert_response :success
            assert response.parsed_body["dismissed_at"].present?
            assert_equal 1, @announcement.dismissals.where(user: @user).count
            post :dismiss, params: { id: @announcement.id }, format: :html
            assert_response :see_other
            @announcement.update!(can_be_closed: false)
            post :dismiss, params: { id: @announcement.id }, format: :turbo_stream
            assert_response :unprocessable_content
            assert_select "turbo-stream[action='remove']", count: 0
            post :dismiss, params: { id: @announcement.id }, format: :json
            assert_response :unprocessable_content
        end

        test "Shield authorizes administration and dismissal through its existing callback" do
            skip "LesliShield is optional" unless defined?(LesliShield)
            @allowed = false
            get :index, format: :json
            assert_response :forbidden
            assert_no_difference("Announcement.count") do
                post :create, params: { announcement: { name: "Denied", message: "Denied" } }, format: :json
                assert_response :forbidden
            end
            post :dismiss, params: { id: @announcement.id }, format: :json
            assert_response :forbidden
            post :dismiss, params: { id: @announcement.id }, format: :turbo_stream
            assert_response :forbidden
            assert_select "turbo-stream[target='application-lesli-notifications']"
            assert_select "turbo-stream[action='remove']", count: 0
        end

        test "missing dismissal returns a Turbo error without removing the banner" do
            post :dismiss, params: { id: 0 }, format: :turbo_stream
            assert_response :not_found
            assert_select "turbo-stream[target='application-lesli-notifications']"
            assert_select "turbo-stream[action='remove']", count: 0
        end
    end
end
