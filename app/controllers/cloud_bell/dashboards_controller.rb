require_dependency "cloud_bell/application_controller"

module CloudBell
    class DashboardsController < ApplicationController

        def show
            #Courier::Bell::Notifications.register(
            #    user: current_user,
            #    subject: 'New notification',
            #    href: '/test'
            #)
        end

    end
end
