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
import app from "LesliVue/app"



// · Import apps and components
import pageIndex from "./pages/index.vue"
import pageEdit from "./pages/edit.vue"
import pageNew from "./pages/new.vue"



// · Cloud app
app("CloudBell", "[list]", "/bell/announcements", [{
    path: "/",
    component: pageIndex
}, {
    path: "/new",
    component: pageNew
}, {
    path: "/:id/edit",
    component: pageEdit
}])
