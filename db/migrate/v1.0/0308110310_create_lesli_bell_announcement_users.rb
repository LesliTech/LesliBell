class CreateLesliBellAnnouncementUsers < ActiveRecord::Migration[7.0]
    def change
        create_table :lesli_bell_announcement_users do |t|
            t.timestamps
            t.datetime :deleted_at, index: true
        end

        add_reference(:lesli_bell_announcement_users, :user, foreign_key: { to_table: :lesli_users })
        add_reference :lesli_bell_announcement_users, :announcement, foreign_key: { to_table: :lesli_bell_announcements }, index: { name: "lesli_bell_announcements_users" }
    end
end
