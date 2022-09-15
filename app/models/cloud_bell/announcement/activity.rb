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
    class Announcement::Activity < CloudObject::Activity
        belongs_to :cloud_object, class_name: "CloudBell::Announcement", foreign_key: "cloud_bell_announcements_id", optional: true
        def self.log_activity_create(current_user, cloud_object)
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_create"
            )
        end
    end
end
