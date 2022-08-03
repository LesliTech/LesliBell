module CloudBell
    class ApplicationController < ApplicationLesliController
        include Interfaces::Application::Responder
        include Interfaces::Application::Requester

        protect_from_forgery with: :exception
    end
end
