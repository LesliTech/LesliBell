=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# · 
::Lesli::User.all.each do |current_user|
    next if current_user.notifications.length > 0
    LesliBell::NotificationService.new(current_user).create("New standard notification")
    LesliBell::NotificationService.new(current_user).create("New info notification created", category: "info")
    LesliBell::NotificationService.new(current_user).create("New success notification created", category: "success")
    LesliBell::NotificationService.new(current_user).create("New warning notification created", category: "warning")
    LesliBell::NotificationService.new(current_user).create("New danger notification created", category: "danger")
end 

# Courier::Bell::Notification.new(current_user, "New notification created")
# Courier::Bell::Notification.new(current_user, "New info notification created", category: "info")
# Courier::Bell::Notification.new(current_user, "New success notification created", category: "success")
# Courier::Bell::Notification.new(current_user, "New warning notification created", category: "warning")
# Courier::Bell::Notification.new(current_user, "New danger notification created", category: "danger")

# Courier::Bell::Notification.new(current_user, "New notification created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
# Courier::Bell::Notification.new(current_user, "New notification info created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "info")
# Courier::Bell::Notification.new(current_user, "New notification success created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "success")
# Courier::Bell::Notification.new(current_user, "New notification warning created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "warning")
# Courier::Bell::Notification.new(current_user, "New notification danger created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "danger")

# Courier::Bell::Notification.new(current_user, "New notification created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell")
# Courier::Bell::Notification.new(current_user, "New notification info created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "info")
# Courier::Bell::Notification.new(current_user, "New notification success created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "success")
# Courier::Bell::Notification.new(current_user, "New notification warning created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "warning")
