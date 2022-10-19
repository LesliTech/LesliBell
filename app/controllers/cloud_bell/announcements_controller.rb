=begin

Copyright (c) 2022, all rights reserved.

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
    class AnnouncementsController < ApplicationController
        before_action :set_announcement, only: [:show, :update, :destroy]

        def privileges
            {
                index: [],
                new: [],
                edit: [],
            }
        end

        # GET /announcements/list
        def list
            respond_to do |format|
                format.html {}
                format.json do
                    respond_with_successful(Announcement.list(current_user, @query, params))
                end
            end
        end

        # GET /announcements
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    respond_with_successful(Announcement.index(current_user, @query))
                end
            end
        end

        # GET /announcements/1
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    return respond_with_not_found unless @announcement
                    return respond_with_successful(@announcement.show(current_user, @query))
                end
            end
        end

        # GET /announcements/new
        def new
        end

        # GET /announcements/1/edit
        def edit
        end

        # POST /announcements
        def create
            announcement = current_user.account.bell.announcements.new(announcement_params)
            announcement.user = current_user

            if announcement.save
                CloudBell::Announcement::Activity.log_activity_create(current_user, announcement)
                respond_with_successful(announcement)
            else
                respond_with_error(announcement.errors.full_messages.to_sentence)
            end
        end

        # PATCH/PUT /announcements/1
        def update
            return respond_with_not_found unless @announcement
            old_attributes = @announcement.attributes

            if @announcement.update(announcement_params)
                new_attributes = @announcement.attributes
                CloudBell::Announcement.log_activity_update(current_user, @announcement, old_attributes, new_attributes)
                respond_with_successful(@announcement.show(current_user, @query))
            else
                respond_with_error(@announcement.errors.full_messages.to_sentence)
            end
        end

        # DELETE /announcements/1
        def destroy
            return respond_with_not_found unless @announcement

            if @announcement.destroy
                CloudBell::Announcement.log_activity_destroy(current_user, @announcement)
                respond_with_successful
            else
                respond_with_error(@announcement.errors.full_messages.to_sentence)
            end
        end

        def options
            respond_with_successful(CloudBell::Announcement.options(current_user, @query))
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_announcement
            @announcement = Announcement.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def announcement_params
            params.require(:announcement).permit(
                :id,
                :name,
                :status,
                :category,
                :message,
                :start_at,
                :end_at,
                :can_be_closed,
                :base_path
            )
        end
    end
end
