require "test_helper"

module LesliBell
    class AnnouncementTest < LesliTesting::ModelTester
        setup do
            @announcement = lesli_bell_announcements(:visible_global).dup
        end

        test "uses explicit publication defaults and has no recipient role" do
            announcement = Announcement.new
            assert announcement.active?
            assert announcement.can_be_closed?
            assert_equal "info", announcement.category
            refute Announcement.column_names.include?("status")
            refute Announcement.column_names.include?("role_id")
        end

        test "requires administrative name and visible message" do
            @announcement.assign_attributes(name: "  ", message: "\n\t")
            assert_not @announcement.valid?
            assert @announcement.errors.added?(:name, :blank)
            assert @announcement.errors.added?(:message, :blank)
        end

        test "requires an author and local account" do
            @announcement.assign_attributes(user: nil, account: nil)
            assert_not @announcement.valid?
            assert @announcement.errors[:user].present?
            assert @announcement.errors[:account].present?
        end

        test "accepts false but rejects absent publication flags" do
            @announcement.assign_attributes(active: false, can_be_closed: false)
            assert @announcement.valid?
            @announcement.assign_attributes(active: nil, can_be_closed: nil)
            assert_not @announcement.valid?
            assert @announcement.errors[:active].present?
            assert @announcement.errors[:can_be_closed].present?
        end

        test "rejects unsupported categories through model validation" do
            @announcement.category = "unknown"
            assert_not @announcement.valid?
            assert @announcement.errors[:category].present?
        end

        test "rejects malformed dates instead of treating them as unrestricted" do
            [:start_at, :end_at].each do |attribute|
                @announcement.assign_attributes(start_at: nil, end_at: nil)
                @announcement.public_send("#{attribute}=", "not a date")
                assert_not @announcement.valid?
                assert @announcement.errors.added?(attribute, :invalid)
            end
        end

        test "dates are optional but an end must follow the start" do
            now = Time.current
            [[nil, nil], [now, nil], [nil, now], [now, now + 1.minute]].each do |start_at, end_at|
                @announcement.assign_attributes(start_at: start_at, end_at: end_at)
                assert @announcement.valid?, @announcement.errors.full_messages.to_sentence
            end
            [now, now - 1.minute].each do |end_at|
                @announcement.assign_attributes(start_at: now, end_at: end_at)
                assert_not @announcement.valid?
                assert @announcement.errors[:end_at].present?
            end
        end

        test "normalizes optional destinations and accepts exact internal paths" do
            @announcement.assign_attributes(path: "  ", url: " ")
            assert_nil @announcement.path
            assert_nil @announcement.url
            ["/", "/support", "/support/tickets/1"].each do |path|
                @announcement.path = path
                assert @announcement.valid?
            end
            ["support", "https://example.com/support", "//example.com", "/support?open=true", "/support#top", "/support/*"].each do |path|
                @announcement.path = path
                assert_not @announcement.valid?, path
            end
        end

        test "accepts internal links and HTTP or HTTPS destinations" do
            [nil, "/", "/support?open=true#tickets", "https://example.com/help", "http://example.com"].each do |url|
                @announcement.url = url
                assert @announcement.valid?, url.to_s
            end
            ["javascript:alert(1)", "data:text/html,example", "//example.com", "/\\example.com", "https:", "help", "https://"].each do |url|
                @announcement.url = url
                assert_not @announcement.valid?, url
                assert @announcement.errors[:url].present?
            end
        end

        test "belongs to its engine account and creator" do
            account = Announcement.reflect_on_association(:account)
            user = Announcement.reflect_on_association(:user)

            assert_equal Account, account.klass
            assert_equal Lesli::User, user.klass
        end

        test "defines the supported categories" do
            assert_equal %w[info danger warning success], Announcement.categories.keys
        end

        test "has explicit dismissal associations" do
            reflection = Announcement.reflect_on_association(:dismissals)

            assert_equal :has_many, reflection.macro
            assert_equal Announcement::User, reflection.klass
        end
    end
end
