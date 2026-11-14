module LesliBell
    class AnnouncementsController < ApplicationController
        prepend_before_action :use_html_for_page_navigation, only: [:index, :show, :new, :edit]
        before_action :load_service
        before_action :load_announcement, only: [:show, :edit, :update, :destroy]
        before_action :load_audience_options, only: [:new, :edit, :create, :update]
        rescue_from ActiveRecord::RecordNotFound do
            if action_name == "dismiss" && request.format.turbo_stream?
                dismissal_error(:not_found)
            else
                respond_with_not_found
            end
        end

        def index
            @announcements = @service.index.result
            respond_with_lesli(json: respond_with_pagination(@announcements))
        end

        def show
            respond_with_lesli(json: announcement_json)
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

        # Turbo preserves its Accept header when following a form's redirect.
        # These actions render complete pages, including Core's HTML banner loader.
        def use_html_for_page_navigation
            request.format = :html if request.get? && request.format.turbo_stream?
        end

        # A failed close must not replace the current page or remove its banner.
        # Authorization still runs through Core's existing callback.
        def respond_with_forbidden(details = {})
            return super unless action_name == "dismiss" && request.format.turbo_stream?

            dismissal_error(:forbidden)
        end

        def dismissal_error(status)
            respond_with_lesli(
                turbo: stream_notification_danger(t("lesli_bell.announcements.dismiss_failed")),
                status: status
            )
        end

        def load_service
            @service = AnnouncementService.new(current_user, query)
        end

        def load_announcement
            @announcement = @service.show(params[:id]).result
        end

        def load_audience_options
            @audience_users = current_user.account.users.order(:email).pluck(:email, :id)
            @audience_roles = current_user.account.roles.order(:name).pluck(:name, :id) if defined?(LesliShield)
        end

        def announcement_json
            @announcement.as_json.merge(user_ids: @announcement.user_ids, role_ids: @announcement.role_ids)
        end

        def announcement_params
            params.require(:announcement).permit(*AnnouncementService::EDITABLE_ATTRIBUTES, user_ids: [], role_ids: []).to_h
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
            respond_with_lesli(json: announcement_json, status: status, redirect: announcement_path(@announcement))
        end
    end
end
