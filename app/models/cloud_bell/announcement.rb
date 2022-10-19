=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module CloudBell
    class Announcement < CloudObject
        belongs_to :account, class_name: "CloudBell::Account", foreign_key: "cloud_bell_accounts_id"
        belongs_to :user, class_name: "::User", foreign_key: "users_id"
        
        before_create :init_announcement

        has_many :activities,   foreign_key: "cloud_bell_announcements_id"
        has_many :users,   foreign_key: "cloud_bell_announcements_id"
        
        def init_announcement
            self.status ||= true
        end
        
        enum category: {
            normal:   "normal",
            info:     "info",
            success:  "success",
            warning:  "warning",
            danger:   "danger",
            link: "link",
            primary: "primary"
        }
        
        def self.list(current_user, query, params)

            filters = params[:f]
            
            # Check the announcements that the user has already closed
            announcements = current_user.account.bell.announcements.left_joins(:users).where(users: { id: nil })
            announcements = announcements.where(base_path: nil )

            unless filters.blank?
                announcements = announcements.where("start_at <= '#{LC::Date2.now.end_of_day}' or start_at is null") if filters[:start_at].present?
                announcements = announcements.where("end_at >= '#{LC::Date2.now.beginning_of_day}' or end_at is null") if filters[:end_at].present?
                announcements = announcements.where("status = ?", filters[:status]) if filters[:status].present?
                announcements_general = announcements.where(base_path: nil )
                announcements = announcements.where("base_path = ?", filters[:base_path]) if filters[:base_path].present?
                announcements = announcements.or(announcements_general)
            end
            
            announcements = announcements.select(
                :id,
                :name,
                :base_path,
                :category,
                :status,
                :message,
                :can_be_closed,
                :end_at,
                :start_at,
                :end_at,
                "concat(user_details.first_name, ' ', user_details.last_name) as user_creator"
            )
            .left_joins(user: [:detail])
            .map do |announcement|
                announcement.attributes.merge({
                    message: announcement[:message].present? ? JSON.parse(announcement[:message]) : {}
                })
            end
        end
        
        def self.index(current_user, query)
            filters = query[:filters]||{}
            
            announcements = current_user.account.bell.announcements
            announcements = announcements.where("start_at <= '#{LC::Date2.now.end_of_day}' or start_at is null") if filters[:start_at]
            announcements = announcements.where("end_at >= '#{LC::Date2.now.beginning_of_day}' or end_at is null") if filters[:end_at]
            
            announcements = announcements.select(
                :id,
                :name,
                :category,
                :status,
                :message,
                :can_be_closed,
                :start_at,
                :end_at,
                LC::Date2.new.date_time.db_timestamps
            )
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(created_at: :desc)
        end

        def show(current_user, query)
            self
        end

        def self.count(current_user)
            current_user.account.bell.announcements.count
        end

        def self.options(current_user, query)
            { 
                categories: self.categories.map {|k,_| {text: k, value: k}}
            }
        end
    end
end
