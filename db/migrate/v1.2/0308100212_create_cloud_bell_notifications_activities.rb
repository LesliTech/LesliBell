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
class CreateCloudBellNotificationsActivities < ActiveRecord::Migration[7.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000004_activities.json')))
        create_table :cloud_bell_notifications_activities do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end

        add_reference   :cloud_bell_notifications_activities, :cloud_bell_notifications, foreign_key: true, index: { name: "cloud_bell_notifications_activities_notifications" }
        add_foreign_key :cloud_bell_notifications_activities, :users, column: :users_id

    end
end
