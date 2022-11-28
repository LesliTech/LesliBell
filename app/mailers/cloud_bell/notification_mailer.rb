=begin

Copyright (c) 2021, all rights reserved.

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
module CloudBell
    class NotificationMailer < ApplicationLesliMailer

        def notification
            user = params[:user]
            notification = params[:notification]
            number_notifications = params[:number_notifications]

            notification.body = "#{number_notifications} " + I18n.t("bell.notifications.mailer_new_notifications") if number_notifications >= 1

            LC::Debug.msg(notification.body)

            self.build_data_from_params({}, {
                notification: notification,
                link_text: I18n.t("bell.notifications.mailer_btn_open_url"),
                user: {
                    full_name: user.full_name
                }
            })

            mail(
                to: email_address_with_name(user.email, user.full_name), 
                subject: notification.subject
            )
        end
    end
end
