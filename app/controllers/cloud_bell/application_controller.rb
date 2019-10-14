module CloudBell
    class ApplicationController < ApplicationLesliController
        protect_from_forgery with: :exception

        before_action :check_account

        def check_account

            if current_user.account.bell.blank?

                # insert reference to the core account
                current_user.account.bell = CloudBell::Account.new
                current_user.account.bell.account = current_user.account
                current_user.account.bell.save!

            end

        end

    end
end
