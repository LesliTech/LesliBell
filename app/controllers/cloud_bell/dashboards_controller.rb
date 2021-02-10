require_dependency "cloud_bell/application_controller"

module CloudBell
    class DashboardsController < ApplicationController

        def show
=begin
            Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell")
            Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "info")
            Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "success")
            Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "warning")
            Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "danger")

            Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell")
            Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "info")
            Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "success")
            Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "warning")
            Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "danger")
=end
            #Courier::Bell::Notifications.register(user: current_user,subject: 'New notification',href: '/test')
            #NotificationMailer.simple.deliver_now
            #UserMailer.welcome.deliver_now
        end

    end
end
