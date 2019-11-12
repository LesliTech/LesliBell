require_dependency "cloud_bell/application_controller"

module CloudBell
    class NotificationsController < ApplicationController
        before_action :set_notification, only: [:show, :edit, :update, :destroy, :api_read]

        # GET /notifications
        def index
            #@notifications = Notification.all.select(:id, :content, :href,:created_at)
            @notifications = current_user.notifications.where(read: false)
            respond_to do |format|
                format.html
                format.json { responseWithSuccessful(@notifications) }
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
        def api_read
            if @notification.user == current_user
                @notification.update(read: true)
                responseWithSuccessful
            else
                responseWithError('Unable to mark notification as read','This notification does not belong to the logged user')
            end
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
