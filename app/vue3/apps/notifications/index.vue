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

// ·
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.notifications")
    }
}

</script>
<template>
    <section class="application-component">

        <lesli-header :title="translations.bell.notifications.view_title_notifications">
            <button @click="url.bell('notifications/new').go()" class="button is-primary" size="is-primary">
                <span class="icon is-small">
                    <span class="material-icons">add</span>
                </span>
                <span >
                    {{ translations.core.shared.view_btn_add }}
                </span>
            </button>
        </lesli-header>

    </section>
</template>
