<script setup>
/*
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
*/


// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from "vue-router"

import dayjs from "dayjs"
import relativeTime from 'dayjs/plugin/relativeTime'

dayjs.extend(relativeTime)


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")
const date = inject("date")


// · import lesli stores
import { useBellNotification } from "LesliBell/vue/stores/notification"


// · implement stores
const storeNotification = useBellNotification()


// ·
const translations = {
    shared: i18n.t("lesli.shared"),
    bell: {
        notifications: i18n.t("lesli_bell.notifications")
    },

    core: {
        shared: I18n.t("core.shared")
    }
}

const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "subject",
    label: "Notification"
}, {
    field: "url",
    label: "Link"
}, {
    field: "status",
    label: "Status",
    align: "center"
}, {
    field: "created_at",
    label: "Sent at"
}]


// · initializing
onMounted(() => {
    storeNotification.fetch()
    // console.log(dayjs("2024-04-14 16:27:55.636").fromNow())
    // console.log(date.date("2024-04-14 16:27:55.636"))
    // console.log(date.time("2024-04-14 16:27:55.636"))
})


</script>
<template>
    <lesli-application-container>

        <lesli-header :title="translations.bell.notifications.view_title">
            <lesli-button icon="refresh">
                {{ translations.shared.button_reload }}
            </lesli-button>
            <!--
            <lesli-link button solid icon="add" :to="url.bell('notifications/new')">
                {{ translations.shared.button_add_new }}
            </lesli-link>
            -->
        </lesli-header>

        <lesli-table
            :columns="columns"
            :records="storeNotification.index.records"
            :pagination="storeNotification.index.pagination"
            @paginate="storeNotification.paginate">
            <template #id="{ value, record }">
                <span :class="['tag', 'is-medium', 'has-text-' + record.category]">
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
                            {{ date.dateTime(value) }}
                        </span>
                    </span>
                </p>
            </template>
        </lesli-table>

    </lesli-application-container>
</template>
