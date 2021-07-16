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
    class Announcement < ApplicationRecord
        belongs_to :account, class_name: "CloudBell::Account", foreign_key: "cloud_bell_accounts_id"
        belongs_to :user, class_name: "::User", foreign_key: "users_id"
        #.where(:expiration_at => LC::Date2.new.date_time.db_column("expiration_at"))
        
        before_create :init_announcement
        
        def init_announcement
            self.status ||= true
        end
        
        enum kind: {
            normal:   "normal",
            info:     "info",
            success:  "success",
            warning:  "warning",
            danger:   "danger"
        }
        
        def self.list(current_user, query)
            filters = query[:filters]||{}
            
            announcements = current_user.account.bell.announcements            
            announcements = announcements.where(base_path: filters[:base_path]) if filters[:base_path].present?
            
            announcements = announcements.select(
                :id,
                :name,
                :kind,
                :status,
                :message,
                :can_be_closed
            )
        end
        
        def self.index(current_user, query)
            announcements = current_user.account.bell.announcements
            .where("expiration_at > ?", LC::Date2.new.get)
            .select(
                :id,
                :name,
                :kind,
                :status,
                :message,
                :can_be_closed,
                LC::Date2.new.date_time.db_timestamps
            )
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(:created_at)

            LC::Response.pagination(
                announcements.current_page,
                announcements.total_pages,
                announcements.total_count,
                announcements.length,
                announcements.map do |announcement|
                    if announcement[:message]
                        announcement[:message][:delta] = ""
                    end
                    
                    announcement
                end
            )
            
            []
        end

        def show(current_user, query)
            self
        end

        def self.count(current_user)
            current_user.account.bell.announcements.count
        end

        def self.options(current_user, query)
            { 
                kinds: self.kinds.map {|k,_| {text: k, value: k}}
            }
        end
    end
end
