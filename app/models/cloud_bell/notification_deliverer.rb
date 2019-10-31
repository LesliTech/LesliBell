module CloudBell
    class NotificationDeliverer < ApplicationRecord
        has_many :notifications, class_name: 'Notification'
    end
end
