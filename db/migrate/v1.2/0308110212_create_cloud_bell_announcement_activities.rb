class CreateCloudBellAnnouncementActivities < ActiveRecord::Migration[7.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000004_activities.json')))
        create_table :cloud_bell_announcement_activities do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end

        add_reference   :cloud_bell_announcement_activities, :cloud_bell_announcements, foreign_key: true, index: { name: "cloud_bell_activities_announcements" }
        add_foreign_key :cloud_bell_announcement_activities, :users, column: :users_id
    end
end
