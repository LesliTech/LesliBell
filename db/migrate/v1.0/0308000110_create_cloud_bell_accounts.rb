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

class CreateCloudBellAccounts < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_accounts do |t|
            t.datetime :deleted_at, index: true
        end
        add_foreign_key :cloud_bell_accounts, :accounts, column: :id
    end
end
