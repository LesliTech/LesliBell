class CreateCloudBellNotificationDeliverers < ActiveRecord::Migration[6.0]
  def change
    create_table :cloud_bell_notification_deliverers do |t|

      t.timestamps
    end
  end
end
