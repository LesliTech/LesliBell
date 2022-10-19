/*

Copyright (c) 2020, all rights reserved.

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
import app from "LesliVue/app2"


// · Import apps 
import dashboardIndex from "./dashboards/actions/index.vue"

import notificationIndex from "./notifications/apps/index.vue"
import notificationEdit from "./notifications/apps/edit.vue"
import notificationNew from "./notifications/apps/new.vue"

import announcementIndex from "./announcements/actions/index.vue"
import announcementEdit from "./announcements/actions/edit.vue"
import announcementNew from "./announcements/actions/new.vue"


// · Cloud app
app("CloudBell", "/bell", "[dashboard]", [{
    path: "/",
    component: dashboardIndex
}, {
    path: "/notifications",
    component: notificationIndex
}, {
    path: "/notifications/new",
    component: notificationNew
}, {
    path: "/notifications/:id/edit",
    component: notificationEdit
}, {
    path: "/announcements",
    component: announcementIndex
}, {
    path: "/announcements/new",
    component: announcementNew
}, {
    path: "/announcements/:id/edit",
    component: announcementEdit
}], {
    notification: null,
})