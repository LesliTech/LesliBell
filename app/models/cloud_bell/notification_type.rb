module CloudBell
    class NotificationType < ApplicationRecord
        has_many :notifications, class_name: 'Notification'
    end
end
