module LesliBell
    class AnnouncementsController < ApplicationController
        before_action :load_service
        before_action :load_announcement, only: [:show, :edit, :update, :destroy]
        rescue_from ActiveRecord::RecordNotFound do
            respond_with_not_found
        end

        def index
            @announcements = @service.index.result
            respond_with_lesli(json: respond_with_pagination(@announcements))
        end

        def show
            respond_with_lesli(json: @announcement)
        end

        def new
            @announcement = Announcement.new
        end

        def edit
        end

        def create
            @service.create(announcement_params)
            save_response(:new, :created, :created)
        end

        def update
            @service.update(announcement_params)
            save_response(:edit, :updated, :ok)
        end

        def destroy
            @service.destroy
            success(t("lesli_bell.announcements.deleted"))
            respond_with_lesli(json: { id: @announcement.id }, redirect: announcements_path)
        end

        def dismiss
            dismissal = @service.dismiss(params[:id]).result
            respond_with_lesli(
                turbo: turbo_stream.remove("announcement-#{dismissal.announcement_id}"),
                json: { id: dismissal.announcement_id, dismissed_at: dismissal.created_at },
                redirect: announcements_path
            )
        rescue ActiveRecord::RecordInvalid => exception
            @announcement = exception.record
            respond_with_lesli(
                html: :show, json: { errors: @announcement.errors.to_hash },
                turbo: stream_notification_danger(@announcement.errors.full_messages.to_sentence),
                status: :unprocessable_content
            )
        end

        private

        def load_service
            @service = AnnouncementService.new(current_user, query)
        end

        def load_announcement
            @announcement = @service.show(params[:id]).result
        end

        def announcement_params
            params.require(:announcement).permit(*AnnouncementService::EDITABLE_ATTRIBUTES).to_h
        end

        def save_response(template, message, status)
            @announcement = @service.result
            unless @service.successful?
                return respond_with_lesli(
                    html: template, json: { errors: @announcement.errors.to_hash },
                    turbo: turbo_stream.replace("announcement-form", partial: "lesli_bell/announcements/form"),
                    status: :unprocessable_content
                )
            end

            success(t("lesli_bell.announcements.#{message}"))
            respond_with_lesli(json: @announcement, status: status, redirect: announcement_path(@announcement))
        end
    end
end
