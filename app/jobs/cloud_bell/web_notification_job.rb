module CloudBell
    class WebNotificationJob < ApplicationJob
        queue_as :default

        def perform(*args)
            CloudCourier::WebNotificationsChannel.broadcast_to(
                'current_user',
                title: 'New things!',
                body: 'New things from CloudBell'
            )
        end
    end
end
