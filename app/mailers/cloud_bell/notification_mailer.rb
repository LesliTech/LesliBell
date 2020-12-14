module CloudBell
    class NotificationMailer < ApplicationMailer

        def simple
            mail(
                to: "ldonis@lomax.com.gt", 
                subject: "Welcome to My Awesome Site"
            )
        end

    end
end
