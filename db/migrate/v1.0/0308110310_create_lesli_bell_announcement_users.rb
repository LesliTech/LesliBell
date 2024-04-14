class CreateLesliBellAnnouncementUsers < ActiveRecord::Migration[7.0]
    def change
        # create_table :cloud_bell_announcement_users do |t|
        #     t.string    :status
        #     t.timestamps
        #     t.datetime :deleted_at, index: true
        # end

        # add_reference :cloud_bell_announcement_users, :users, foreign_key: true
        # add_reference :cloud_bell_announcement_users, :cloud_bell_announcements, foreign_key: true, index: { name: "cloud_bell_announcements_users" }
    end
end
