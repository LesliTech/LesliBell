class CreateLesliBellAnnouncementRecipients < ActiveRecord::Migration[8.1]
    def change
        create_table :lesli_bell_announcement_user_recipients do |t|
            t.references :announcement, null: false, foreign_key: { to_table: :lesli_bell_announcements }, index: false
            t.references :user, null: false, foreign_key: { to_table: :lesli_users }
            t.timestamps
            t.index [:announcement_id, :user_id], unique: true, name: "index_bell_audience_users"
        end

        create_table :lesli_bell_announcement_role_recipients do |t|
            t.references :announcement, null: false, foreign_key: { to_table: :lesli_bell_announcements }, index: false
            t.references :role, null: false, foreign_key: { to_table: :lesli_roles }
            t.timestamps
            t.index [:announcement_id, :role_id], unique: true, name: "index_bell_audience_roles"
        end
    end
end
