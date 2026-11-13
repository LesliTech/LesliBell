class CreateLesliBellAnnouncementUsers < ActiveRecord::Migration[7.0]
    def change
        create_table :lesli_bell_announcement_users do |t|
            t.timestamps
        end

        add_reference(:lesli_bell_announcement_users, :user, null: false, foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_bell_announcement_users, :announcement, null: false, foreign_key: { to_table: :lesli_bell_announcements }, index: false)
        add_index(:lesli_bell_announcement_users, [:announcement_id, :user_id], unique: true, name: "index_bell_dismissals_on_announcement_and_user")
    end
end
