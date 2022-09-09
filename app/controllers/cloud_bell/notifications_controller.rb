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
                    respond_with_pagination(Notification.index(current_user, @query))
                }
            end
        end

        # GET /notifications/1
        def show
            respond_with_successful(@notification)
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

            notification = CloudBell::NotificationService.generate(
                current_user,
                notification_params[:subject],
                url: notification_params[:url],
                body: notification_params[:body],
                media: notification_params[:media],
                payload: notification_params[:payload],
                category: notification_params[:category],
                user_receiver_id: notification_params[:user_receiver_id],
                notification_type: notification_params[:notification_type],
                role_receiver_names: notification_params[:role_receiver_names],
                user_receiver_emails: notification_params[:user_receiver_emails],
            )

            CloudBell::Notification.log_activity_create(current_user, notification)
            respond_with_successful(notification)

        end

        # PATCH/PUT /notifications/1
        def update
            old_attributes = @notification.attributes

            if @notification.update(notification_params)
                new_attributes = @notification.attributes
                CloudBell::Notification.log_activity_update(current_user, @notification, old_attributes, new_attributes)
                respond_with_successful(@notification)
            else
                render :edit
            end
        end

        # DELETE /notifications/1
        def destroy
            @notification.destroy
            CloudBell::Notification.log_activity_destroy(current_user, @notification)
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
            params.require(:notification).permit(
                :id,
                :url,
                :body,
                :media,
                :subject,
                :category,
                :user_receiver_id,
                :notification_type,
                payload: {},
                role_receiver_names: [],
                user_receiver_emails: [],
            )
        end

    end
end
