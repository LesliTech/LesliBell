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
    class Announcement::UsersController < ApplicationController
        before_action :set_announcement_user, only: [:show, :update, :destroy]
        before_action :set_announcement, only: [:show, :update, :destroy, :create]

        def privileges
            {
                new: [],
            }
        end

        # GET /announcement/users
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    respond_with_successful(Announcement::User.index(current_user, @query))
                end
            end
        end

        # GET /announcement/users/1
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    return respond_with_not_found unless @announcement_user
                    return respond_with_successful(@announcement_user.show(current_user, @query))
                end
            end
        end

        # GET /announcement/users/new
        def new
        end

        # GET /announcement/users/1/edit
        def edit
        end

        # POST /announcement/users
        def create
            announcement_user = Announcement::User.new()
            announcement_user.user = current_user
            announcement_user.status = 'closed'
            announcement_user.announcement = @announcement

            if announcement_user.save
                respond_with_successful(announcement_user)
            else
                respond_with_error(announcement_user.errors.full_messages.to_sentence)
            end
        end

        # PATCH/PUT /announcement/users/1
        def update
            return respond_with_not_found unless @announcement_user

            if @announcement_user.update(announcement_user_params)
                respond_with_successful(@announcement_user.show(current_user, @query))
            else
                respond_with_error(@announcement_user.errors.full_messages.to_sentence)
            end
        end

        # DELETE /announcement/users/1
        def destroy
            return respond_with_not_found unless @announcement_user

            if @announcement_user.destroy
                respond_with_successful
            else
                respond_with_error(@announcement_user.errors.full_messages.to_sentence)
            end
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_announcement_user
            @announcement_user = current_user.account.announcement_users.find_by_id(params[:id])
        end

        def set_announcement
            @announcement = current_user.account.bell.announcements.find_by_id(params[:announcement_id])
        end

        # Only allow a list of trusted parameters through.
        def announcement_user_params
            params.fetch(:announcement_user).permit(:id, :status)
        end
    end
end
