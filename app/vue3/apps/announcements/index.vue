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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")
const date = inject("date")


// · import lesli stores
import { useBellAnnouncement } from "CloudBell/stores/announcement"


// · implement stores
const storeAnnouncement = useBellAnnouncement()


// ·
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.announcements")
    }
}

const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "name",
    label: "Name"
}, {
    field: "status",
    label: "Status",
    align: "center"
}, {
    field: "created_at_date",
    label: "Sent at"
}]

// · initializing
onMounted(() => {
    storeAnnouncement.fetch()
})

</script>
<template>
    <section class="application-component">

        <lesli-header :title="translations.bell.notifications.view_title_notifications">
            <button @click="router.push(url.bell('notifications/new').s)" class="button is-primary" size="is-primary">
                <span class="icon is-small">
                    <span class="material-icons">add</span>
                </span>
                <span >
                    {{ translations.core.shared.view_btn_add }}
                </span>
            </button>
        </lesli-header>

        <lesli-table
            :columns="columns"
            :records="storeAnnouncement.records"
            :pagination="storeAnnouncement.pagination"
            @paginate="storeAnnouncement.paginate">
            <template #id="{ value, record }">
                <span :class="['tag', 'is-medium', 'is-' + record.category]">
                    {{ value }}
                </span>
            </template>
            <template #subject="{ column, value, record }">
                <h4>{{ record.subject }}</h4>
                <p>{{ record.body }}</p>
            </template>
            <template #url="{ value }">
                <a :href="value" class="has-text-link hover">{{ value }}</a>
            </template>
            <template #created_at="{ value }">
                <p>
                    <span class="icon-text">
                        <span class="icon">
                            <span class="has-text-grey material-icons">
                                calendar_month
                            </span>
                        </span>
                        <span>
                            {{ date.date(value) }}
                        </span>
                    </span>
                </p>
                <p>
                    <span class="icon-text">
                        <span class="icon">
                            <span class="has-text-grey material-icons">
                                schedule
                            </span>
                        </span>
                        <span>
                            {{ date.time(value) }}
                        </span>
                    </span>
                </p>
            </template>
        </lesli-table>

    </section>
</template>
