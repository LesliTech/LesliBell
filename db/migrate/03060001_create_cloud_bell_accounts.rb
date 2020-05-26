class CreateCloudBellAccounts < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_bell_accounts do |t|
            t.datetime :deleted_at, index: true
        end
        add_foreign_key :cloud_bell_accounts, :accounts, column: :id
    end
end
