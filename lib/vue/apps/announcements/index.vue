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
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useBellAnnouncement } from "LesliBell/vue/stores/announcement"


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")
const date = inject("date")


// · implement stores
const storeAnnouncement = useBellAnnouncement()


// ·
const translations = {
    lesli: i18n.t("lesli.shared"),
    announcements: i18n.t("lesli_bell.announcements"),


    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        announcements: I18n.t("lesli_bell.announcements")
    }
}

// ·
const columns = [{
    field: "id",
    label: translations.announcements.column_id
}, {
    field: "name",
    label: translations.announcements.column_name
}, {
    field: "category",
    label: translations.announcements.column_category
}, {
    field: "start_at",
    label: translations.announcements.column_start_at
}, {
    field: "end_at",
    label: translations.announcements.column_end_at
}]

// · initializing
onMounted(() => {
    storeAnnouncement.fetch()
})

</script>
<template>
    <lesli-application-container>
        <lesli-header :title="translations.announcements.view_title">
            <lesli-button :to="url.bell('announcements/new')" icon="add">
                {{ translations.core.shared.view_btn_add }}
            </lesli-button>
        </lesli-header>

        <lesli-table
            :columns="columns"
            :records="storeAnnouncement.announcements.records"
            :pagination="storeAnnouncement.announcements.pagination"
            @paginate="storeAnnouncement.paginate">
            <template #id="{ value, record }">
                <span :class="['tag', 'is-medium', 'is-' + record.category]">
                    {{ value }}
                </span>
            </template>
            <template #category="{ value }">
                <p :class="[`has-background-${value}-light`, 'px-2']">
                    {{ value }}
                </p>
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
    </lesli-application-container>
</template>
