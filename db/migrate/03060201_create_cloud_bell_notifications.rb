class CreateCloudBellNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_notifications do |t|
            t.timestamps
        end
        add_reference :cloud_bell_notifications, :cloud_bell_accounts, foreign_key: true
    end
end
