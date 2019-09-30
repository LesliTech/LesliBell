require_dependency "cloud_bell/application_controller"

module CloudBell
    class DashboardsController < ApplicationController
        before_action :set_dashboard, only: [:show]

        def default
        end

    end
end
