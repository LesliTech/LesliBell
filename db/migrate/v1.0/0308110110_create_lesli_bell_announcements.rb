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

class CreateLesliBellAnnouncements < ActiveRecord::Migration[6.0]
    def change
        create_table :lesli_bell_announcements do |t|
            t.string    :url, index: true
            t.string    :name
            t.string    :category
            t.string    :base_path
            t.text      :message
            t.boolean   :status
            t.datetime  :start_at
            t.datetime  :end_at
            t.boolean   :can_be_closed, :default => true
            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference(:lesli_bell_announcements, :user, foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_bell_announcements, :role, foreign_key: { to_table: :lesli_roles })
        add_reference(:lesli_bell_announcements, :account, foreign_key: { to_table: :lesli_accounts })
    end
end
