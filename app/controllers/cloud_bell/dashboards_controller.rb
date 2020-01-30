require_dependency "cloud_bell/application_controller"

module CloudBell
    class DashboardsController < ApplicationController
        before_action :set_dashboard, only: [:show]

        def default
            Courier::Bell::Notifications.register(
                user: current_user,
                subject: 'New notification',
                href: '/test'
            )
        end

    end
end
