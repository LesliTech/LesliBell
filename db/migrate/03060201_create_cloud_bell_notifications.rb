class CreateCloudBellNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_notifications do |t|
            t.string :subject
            t.text   :body
            t.string :href
            t.string :format
            t.boolean :read
            t.timestamps
        end
        add_reference :cloud_bell_notifications, :cloud_bell_notification_deliverer, foreign_key: true, index: { name: 'bell_notifications_deliverers'}
        add_reference :cloud_bell_notifications, :users, foreign_key: true
        add_reference :cloud_bell_notifications, :cloud_bell_accounts, foreign_key: true
    end
end
