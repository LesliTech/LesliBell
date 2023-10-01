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

// · import lesli stores
import { useBellAnnouncement } from "LesliBell/stores/announcement"

// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")
const date = inject("date")


// · implement stores
const storeAnnouncement = useBellAnnouncement()


// ·
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        announcements: I18n.t("bell.announcements")
    }
}

const columns = [{
    field: "id",
    label: translations.bell.announcements.column_id
}, {
    field: "name",
    label: translations.bell.announcements.column_name
}, {
    field: "start_at",
    label: translations.bell.announcements.column_start_at
}, {
    field: "end_at",
    label: translations.bell.announcements.column_end_at
}]

// · initializing
onMounted(() => {
    storeAnnouncement.fetch()
})

</script>
<template>
    <section class="application-component">
        <lesli-header :title="translations.bell.announcements.view_title_notifications">
            <lesli-button :to="url.bell('announcements/new')" icon="add">
                {{ translations.core.shared.view_btn_add }}
            </lesli-button>
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
            <template #start_at="{ value }">
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
            </template>
            <template #end_at="{ value }">
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
            </template>
        </lesli-table>

    </section>
</template>
