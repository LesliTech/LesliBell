class AlterCloudBellAnnouncements < ActiveRecord::Migration[7.0]
    def change
        change_column(:cloud_bell_announcements, :message, :text)
    end
end
