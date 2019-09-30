class CreateCloudBellMessages < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_messages do |t|
            t.timestamps
        end
        add_reference :cloud_bell_messages, :cloud_bell_accounts, foreign_key: true
    end
end
