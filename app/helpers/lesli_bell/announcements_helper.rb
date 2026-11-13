module LesliBell
    module AnnouncementsHelper
        def announcement_categories
            Announcement.categories.keys.map { |category| [t("lesli_bell.announcements.categories.#{category}"), category] }
        end

        def announcement_audiences
            Announcement.audiences.keys.map { |audience| [t("lesli_bell.announcements.audiences.#{audience}"), audience] }
        end

        def announcement_audience_summary(announcement)
            return t("lesli_bell.announcements.audiences.account") if announcement.audience_account?

            labels = announcement.recipient_users.pluck(:email) + announcement.recipient_roles.pluck(:name)
            labels.presence&.join(", ") || t("lesli_bell.announcements.audience_empty")
        end

        def announcement_datetime(value)
            value ? l(value, format: :long) : t("lesli_bell.announcements.no_limit")
        end
    end
end
