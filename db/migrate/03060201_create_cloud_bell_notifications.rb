class CreateCloudBellNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_notifications do |t|
            t.string :subject
            t.text   :body
            t.string :url
            t.string :category
            t.string :sender
            t.boolean :read, default: false
            t.timestamps
        end
        add_reference :cloud_bell_notifications, :users, foreign_key: true
        add_reference :cloud_bell_notifications, :cloud_bell_accounts, foreign_key: true
    end
end
