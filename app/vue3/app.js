/*

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

*/


// · Import main app
import app from "LesliVue/app"


// · Import apps and components
import appDashboard from "LesliVue/cloud-objects/dashboards/apps/show.vue"

import appNotificationsIndex from "./apps/notifications/index.vue"
import appNotificationsNew from "./apps/notifications/new.vue"

import appAnnouncementsIndex from "./apps/announcements/index.vue"
import appAnnouncementsNew from "./apps/announcements/new.vue"


// · Cloud app
app("CloudBell", [{
    path: "/",
    component: appDashboard
}, {
    path: "/notifications",
    component: appNotificationsIndex
}, {
    path: "/notifications/new",
    component: appNotificationsNew
}, {
    path: "/announcements",
    component: appAnnouncementsIndex
}, {
    path: "/announcements/new",
    component: appAnnouncementsNew
}])

