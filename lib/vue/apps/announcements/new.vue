<script setup>
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

// · import vue tools
import { onMounted } from "vue"

// · import components
import ComponentAnnouncementForm from "LesliBell/apps/announcements/components/form.vue"

// ·
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.notifications"),
        announcements: I18n.t("bell.announcements")
    }
}

// · initializing
onMounted(() => {})

</script>
<template>
    <section class="application-component">

        <lesli-header :title="translations.bell.announcements.view_title_new_announcement"></lesli-header>

        <component-announcement-form></component-announcement-form>

    </section>
</template>
