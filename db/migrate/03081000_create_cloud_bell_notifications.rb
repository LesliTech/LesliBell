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

class CreateCloudBellNotifications < ActiveRecord::Migration[6.0]

    def change
        create_table :cloud_bell_notifications do |t|
            t.string    :subject
            t.text      :body
            t.string    :url
            t.string    :kind
            t.string    :sender
            t.string    :status
            t.datetime  :deleted_at, index: true            
            t.timestamps
        end
        add_reference :cloud_bell_notifications, :users, foreign_key: true
        add_reference :cloud_bell_notifications, :cloud_bell_accounts, foreign_key: true
    end

end
