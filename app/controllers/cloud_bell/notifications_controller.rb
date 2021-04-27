=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require_dependency "cloud_bell/application_controller"

module CloudBell
    class NotificationsController < ApplicationController
        before_action :set_notification, only: [:show, :edit, :update, :destroy, :read]

        # GET /notifications
        def index
            respond_to do |format|
                format.html {  }
                format.json { 
                    respond_with_successful(Notification.index(current_user, @query)) 
                }
            end
        end

        # GET /notifications/1
        def show
        end

        # GET /notifications/new
        def new
            @notification = Notification.new
        end

        # GET /notifications/1/edit
        def edit
        end

        # POST /notifications
        def create

            notification = Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell")
            ActionCable.server.broadcast('web_notifications_channel', {
                notifications: Courier::Bell::Notification.count(current_user),
                notification: notification
            })

            respond_with_successful()
            return 
            @notification = Notification.new(notification_params)

            if @notification.save
                redirect_to @notification, notice: 'Notification was successfully created.'
            else
                render :new
            end
        end

        # PATCH/PUT /notifications/1
        def update
            if @notification.update(notification_params)
                redirect_to @notification, notice: 'Notification was successfully updated.'
            else
                render :edit
            end
        end

        # DELETE /notifications/1
        def destroy
            @notification.destroy
            redirect_to notifications_url, notice: 'Notification was successfully destroyed.'
        end

        def options
            return respond_with_successful(Notification.options)
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_notification
            @notification = Notification.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def notification_params
            params.fetch(:notification, {})
        end

    end
end
