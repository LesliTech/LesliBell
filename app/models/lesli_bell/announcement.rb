require "uri"

module LesliBell
    class Announcement < ApplicationRecord
        belongs_to :account, class_name: "LesliBell::Account"
        # The user is the author, not a recipient of the announcement.
        belongs_to :user, class_name: "::Lesli::User"
        has_many :dismissals, class_name: "LesliBell::Announcement::User", inverse_of: :announcement

        has_many :user_recipients, class_name: "LesliBell::Announcement::UserRecipient", inverse_of: :announcement
        has_many :role_recipients, class_name: "LesliBell::Announcement::RoleRecipient", inverse_of: :announcement
        has_many :recipient_users, through: :user_recipients, source: :user
        has_many :recipient_roles, through: :role_recipients, source: :role

        enum :audience, { account: "account", specific: "specific" }, prefix: true, default: :account, validate: true

        # Submitted IDs remain available to the form when validation fails.
        attr_writer :user_ids, :role_ids
        attr_accessor :allow_empty_audience

        enum :category, {
            :info => 'info',
            :danger => 'danger',
            :warning => 'warning',
            :success => 'success'
        }, default: :info, validate: true

        attribute :active, :boolean, default: true
        attribute :can_be_closed, :boolean, default: true

        normalizes :name, :message, with: ->(value) { value.strip }
        normalizes :path, :url, with: ->(value) { value.strip.presence }

        validates :name, :message, presence: true
        validates :active, :can_be_closed, inclusion: { in: [true, false] }
        validates :end_at, comparison: { greater_than: :start_at },
            if: -> { start_at.present? && end_at.present? }

        # Match request.path exactly: no host, query string, fragment, or wildcard.
        validates :path, format: { with: %r{\A/(?!/)[^?#\\\s*]*\z} }, allow_nil: true
        validate :url_is_a_supported_destination
        validate :audience_is_valid
        validate :publication_dates_are_valid

        def user_ids
            @user_ids || user_recipients.pluck(:user_id)
        end

        def role_ids
            @role_ids || role_recipients.pluck(:role_id)
        end

        def clear_audience_selection
            @user_ids = @role_ids = nil
            self.allow_empty_audience = false
        end

        # Keep a specific audience specific even after its final recipient is removed.
        def deactivate_without_recipients!
            return unless audience_specific?
            return if user_recipients.exists? || role_recipients.exists?

            # An empty specific audience is intentionally retained but cannot be published.
            # Skip the recipient-presence validation when disabling it.
            update_columns(active: false, updated_at: Time.current)
        end

        private

        # Rails casts malformed datetime input to nil; distinguish it from an empty field.
        def publication_dates_are_valid
            [:start_at, :end_at].each do |attribute|
                if public_send("#{attribute}_before_type_cast").present? && public_send(attribute).nil?
                    errors.add(attribute, :invalid)
                end
            end
        end

        def audience_is_valid
            if audience_specific? && user_ids.empty? && role_ids.empty? && !allow_empty_audience
                errors.add(:base, I18n.t("lesli_bell.announcements.audience_required"))
            end

            core_account = account&.account
            return unless core_account

            valid_users = core_account.users.where(id: user_ids).pluck(:id).map(&:to_s)
            unless (user_ids.map(&:to_s) - valid_users).empty?
                errors.add(:base, I18n.t("lesli_bell.announcements.invalid_users"))
            end

            valid_roles = defined?(LesliShield) ? core_account.roles.where(id: role_ids).pluck(:id).map(&:to_s) : []
            unless (role_ids.map(&:to_s) - valid_roles).empty?
                errors.add(:base, I18n.t("lesli_bell.announcements.invalid_roles"))
            end
        end

        def url_is_a_supported_destination
            return if url.nil?

            destination = URI.parse(url)
            internal_path = destination.relative? && url.start_with?("/") && !url.start_with?("//")
            web_url = destination.is_a?(URI::HTTP) && destination.host.present?
            errors.add(:url, :invalid) unless internal_path || web_url
        rescue URI::InvalidURIError
            errors.add(:url, :invalid)
        end
    end
end
