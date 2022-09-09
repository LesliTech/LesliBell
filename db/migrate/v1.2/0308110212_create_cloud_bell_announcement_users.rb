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
class CreateCloudBellAnnouncementUsers < ActiveRecord::Migration[7.0]
    def change
        create_table :cloud_bell_announcement_users do |t|
            t.string    :status
            t.timestamps
        end
        
        add_reference :cloud_bell_announcement_users, :users, foreign_key: true
        add_reference :cloud_bell_announcement_users, :cloud_bell_announcements, foreign_key: true, index: { name: "cloud_bell_announcements_users" }
    end
end
