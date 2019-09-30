class CreateCloudBellEmails < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_emails do |t|
            t.timestamps
        end
        add_reference :cloud_bell_emails, :cloud_bell_accounts, foreign_key: true
    end
end
