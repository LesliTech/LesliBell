class CreateCloudBellNotificationTypes < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_notification_types do |t|
            t.timestamps
        end
        add_reference :cloud_bell_notification_types, :cloud_bell_accounts, foreign_key: true
    end
end
