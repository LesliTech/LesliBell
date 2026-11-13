require "uri"

module LesliBell
    class Announcement < ApplicationRecord
        belongs_to :account, class_name: "LesliBell::Account"
        # The user is the author, not a recipient of the announcement.
        belongs_to :user, class_name: "::Lesli::User"
        has_many :dismissals, class_name: "LesliBell::Announcement::User", inverse_of: :announcement

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

        private

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
