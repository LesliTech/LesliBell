module CloudBell
  class SendNotificationsJob < ApplicationJob
    queue_as :default

    def perform(user,notifications)
        #Create a notification for every user
        notifications = user.account.bell.notifications.create(notifications)
        notifcations_ids = notifications.map(&:id) #Get the ids of the notifications created            

        #Create an activity log entry for each notification created
        notifcations_ids.each do |id|
            notification_created = CloudBell::Notification.find_by_id(id)
            CloudBell::Notification::Activity.log_activity_create(user, notification_created)
        end

    end
  end
end
