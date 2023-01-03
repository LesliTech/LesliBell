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

current_user = User.first
Courier::Bell::Notification.new(current_user, "New notification created")
Courier::Bell::Notification.new(current_user, "New info notification created", category: "info")
Courier::Bell::Notification.new(current_user, "New success notification created", category: "success")
Courier::Bell::Notification.new(current_user, "New warning notification created", category: "warning")
Courier::Bell::Notification.new(current_user, "New danger notification created", category: "danger")

Courier::Bell::Notification.new(current_user, "New notification created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
Courier::Bell::Notification.new(current_user, "New notification info created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "info")
Courier::Bell::Notification.new(current_user, "New notification success created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "success")
Courier::Bell::Notification.new(current_user, "New notification warning created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "warning")
Courier::Bell::Notification.new(current_user, "New notification danger created with body", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", category: "danger")

Courier::Bell::Notification.new(current_user, "New notification created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell")
Courier::Bell::Notification.new(current_user, "New notification info created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "info")
Courier::Bell::Notification.new(current_user, "New notification success created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "success")
Courier::Bell::Notification.new(current_user, "New notification warning created with body and link", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "warning")
