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

            # NOTE: the query must be created in this specific order, if not ActiveRecord creates weird sql
            # due the OR statement we are usign to get the announcements with a path
            
            # Get all the announcements for the current user
            announcements = current_user.account.bell.announcements

            # joining to the announcement_users table, to see if the users already mark the announcement as read
            announcements = announcements.left_joins(:users)

            # get the announcements without a specific path (global announcements)
            announcements = announcements.where(base_path: nil)

            # get the announcements with a specific path (to show only in a specific page)
            announcements = announcements.or(Announcement.where("base_path = ?", filters[:base_path])) if params.dig(:f, :base_path)

            # get the announcements with a start date greater than or equal to current date and with expiration date less or equal than current date
            announcements = announcements.where("cloud_bell_announcements.start_at <= '#{LC::Date.now.end_of_day}' or start_at is NULL")
            .where("cloud_bell_announcements.end_at >= '#{LC::Date.now.beginning_of_day}' or end_at is NULL")
            .where("cloud_bell_announcements.status = TRUE")

            # get the announcements that are not marked as read by the user
            announcements = announcements.where(users: { id: nil })

            announcements.select(
                :id,
                :name,
                :category,
                :message,
                :can_be_closed,
                :base_path,
                :start_at,
                :end_at
            )

        end
        
        def self.index(current_user, query, params)
            
            filters = params[:f]
            
            unless query.dig(:order, :by).blank?
                order_string = query.dig(:order, :by)
            end

            announcements = current_user.account.bell.announcements

            if params.dig(:f, :base_path)
                announcements = announcements
                .where(base_path: nil) # get the announcements without a specific path (global announcements)
                .where("cloud_bell_announcements.status = TRUE")
                .or(Announcement.where("base_path = ?", filters[:base_path])) # get the announcements with a specific path (to show only in a specific page)
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
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(order_string.concat(" ").concat(query.dig(:order, :dir)))

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
