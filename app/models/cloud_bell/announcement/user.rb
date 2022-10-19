=begin
Copyright (c) 2022, all rights reserved.

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
    class Announcement::User < ApplicationRecord
        belongs_to :announcement, class_name: "CloudBell::Announcement", foreign_key: "cloud_bell_announcements_id", optional: false
        belongs_to :user, class_name: "::User", foreign_key: "users_id"

        def self.index(current_user, query)
            []
        end

        def show(current_user, query)
            self
        end
    end
    end