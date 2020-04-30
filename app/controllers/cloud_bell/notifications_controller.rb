=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
                format.json do
                    notifications = CloudBell::Notification
                    .where(user: current_user, read: false)
                    .order(created_at: :DESC)
                    .map do |notification|
                        {
                            id: notification[:id],
                            subject: notification[:subject],
                            category: notification[:category],
                            url: notification[:url],
                            created_at: Courier::Core::Date.distance_to_words(notification[:created_at]),
                            read: notification[:read],
                        }
                    end
                    responseWithSuccessful(notifications)
                end
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

        # PUT /api/notifications/1/read
        def read
            if @notification.user == current_user
                @notification.update(read: true)
                responseWithSuccessful
            else
                responseWithError('Unable to mark notification as read','This notification does not belong to the logged user')
            end
        end

        def read_all
            current_user.account.bell.notifications
            .where(read: false, user:current_user)
            .update_all(:read => true)
            responseWithSuccessful()
        end

        def options
            return responseWithSuccessful(Notification.options)
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
