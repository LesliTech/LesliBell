require_dependency "cloud_bell/application_controller"

module CloudBell
  class NotificationDeliverersController < ApplicationController
    before_action :set_notification_deliverer, only: [:show, :edit, :update, :destroy]

    # GET /notification_deliverers
    def index
      @notification_deliverers = NotificationDeliverer.all
    end

    # GET /notification_deliverers/1
    def show
    end

    # GET /notification_deliverers/new
    def new
      @notification_deliverer = NotificationDeliverer.new
    end

    # GET /notification_deliverers/1/edit
    def edit
    end

    # POST /notification_deliverers
    def create
      @notification_deliverer = NotificationDeliverer.new(notification_deliverer_params)

      if @notification_deliverer.save
        redirect_to @notification_deliverer, notice: 'Notification deliverer was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /notification_deliverers/1
    def update
      if @notification_deliverer.update(notification_deliverer_params)
        redirect_to @notification_deliverer, notice: 'Notification deliverer was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /notification_deliverers/1
    def destroy
      @notification_deliverer.destroy
      redirect_to notification_deliverers_url, notice: 'Notification deliverer was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_notification_deliverer
        @notification_deliverer = NotificationDeliverer.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def notification_deliverer_params
        params.fetch(:notification_deliverer, {})
      end
  end
end
