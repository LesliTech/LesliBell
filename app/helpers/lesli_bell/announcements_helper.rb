module LesliBell
    module AnnouncementsHelper
        def announcement_categories
            Announcement.categories.keys.map { |category| [t("lesli_bell.announcements.categories.#{category}"), category] }
        end

        def announcement_datetime(value)
            value ? l(value, format: :long) : t("lesli_bell.announcements.no_limit")
        end
    end
end
