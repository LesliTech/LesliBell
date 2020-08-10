=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module CloudBell
    class Notification < ApplicationRecord
        belongs_to :account, class_name: "CloudBell::Account", foreign_key: "cloud_bell_accounts_id"
        belongs_to :user, class_name: "::User", foreign_key: "users_id"

        enum category: {
            link: "link",
            info: "info",
            danger: "danger",
            primary: "primary",
            success: "success",
            warning: "warning"
        }

        enum sender: {
            web: "web",
            email: "email"
        }

        def self.options
            {
                categories: categories.map { |key, value| {value: key, text: value} },
                sender: senders.map { |key, value| {value: key, text: value} }
            }
        end


        def self.index current_user, query, view_type

            if view_type == "count"
                if defined?(DeutscheLeibrenten)
                    notifications = current_user.account.focus.tasks
                    .joins(:status, :detail)
                    .where(user_main: current_user)
                    .where("cloud_focus_workflow_statuses.initial = ?", true)
                    .where("cloud_focus_task_details.deadline <= ?", LC::Date.now.end_of_day)
                    .count
                else 
                    notifications = current_user.account.bell.notifications
                    .where(user: current_user, read: false)
                    .count
                end
            else
                notifications = CloudBell::Notification
                .where(user: current_user, read: false)
                .order(created_at: :DESC)
                .limit(50)
                .map do |notification|
                    {
                        id: notification[:id],
                        subject: notification[:subject],
                        category: notification[:category],
                        url: notification[:url],
                        created_at: Courier::Core::Date.distance_to_words(notification[:created_at]),
                        read: notification[:read],
                    }
                end
            end
        end


    end
end
