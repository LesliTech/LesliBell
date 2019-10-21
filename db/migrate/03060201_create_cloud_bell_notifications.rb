class CreateCloudBellNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_notifications do |t|
            t.string :content
            t.string :href
            t.boolean :read
            t.timestamps
        end
        add_reference :cloud_bell_notifications, :cloud_bell_notification_types, foreign_key: true, index: { name: 'bell_notifications_types'}
        add_reference :cloud_bell_notifications, :users, foreign_key: true
        add_reference :cloud_bell_notifications, :cloud_bell_accounts, foreign_key: true
    end
end
