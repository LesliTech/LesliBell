class AlterCloudBellNotifications < ActiveRecord::Migration[6.1]
    def change
        add_column :cloud_bell_notifications, :type, :string
        add_column :cloud_bell_notifications, :media, :string
        add_column :cloud_bell_notifications, :payload, :json
    end
end
