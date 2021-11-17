class AlterCloudBellAccounts < ActiveRecord::Migration[6.0]
    def change
        add_timestamps(:cloud_bell_accounts)
    end
end
