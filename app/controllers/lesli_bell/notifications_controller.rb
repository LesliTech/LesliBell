module LesliBell
    class NotificationsController < ApplicationController
        before_action :set_notification, only: %i[ show edit update destroy ]

        # GET /notifications
        def index
            @notifications = respond_as_pagination(NotificationService.new(current_user, query).index)
        end

        # GET /notifications/1
        def show
        end

        # GET /notifications/new
        def new
        end

        # GET /notifications/1/edit
        def edit
        end

        # POST /notifications
        def create
        @notification = Notification.new(notification_params)

        if @notification.save
        redirect_to @notification, notice: "Notification was successfully created."
        else
        render :new, status: :unprocessable_entity
        end
        end

        # PATCH/PUT /notifications/1
        def update
            respond_with_successful(NotificationService.new(current_user).read(params[:id]))
        end

        # DELETE /notifications/1
        def destroy
        @notification.destroy
        redirect_to notifications_url, notice: "Notification was successfully destroyed.", status: :see_other
        end

        private
        # Use callbacks to share common setup or constraints between actions.
        def set_notification
        @notification = Notification.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def notification_params
            params.require(:notification).permit(
                :id
            )
        end
    end
end
