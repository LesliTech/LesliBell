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
import { onMounted, ref, watch } from "vue"

// · import store
import { useBellAnnouncement } from "LesliBell/stores/announcement"

import editorRichText from "Lesli/components/editors/richtext.vue"
import RichtextViewer from "Lesli/components/editors/richtext-viewer.vue"


// · implement store
const announcementStore = useBellAnnouncement()

// . Defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.notifications"),
        announcements: I18n.t("bell.announcements")
    }
}

const closeOptions = {
    yes: { 
        label: "yes", 
        value: true
    },
    no: {
        label: "no",
        value: false
    }
    
}

const selectOptions = [
    { label: "Info", value: "info"}, 
    { label: "Alert", value: "danger"},
    { label: "Primary", value: "primary"},
    { label: "Link", value: "link"},
    { label: "Success", value: "success"},
    { label: "Warning", value: "warning"}
]

/**
 * @description This function is used to verify that the start date is before the end date
 */
function updateDates(){
    if (announcementStore.record.start_at != "" && announcementStore.record.end_at != "") {
        if (announcementStore.record.start_at >= announcementStore.record.end_at){
            announcementStore.record.start_at = ""
            announcementStore.msg.danger("Select valid range for date")
        }
    }
}


// · initializing
onMounted(() => {
    announcementStore.getUsers()
    announcementStore.getRoles()
})
</script>

<template>
    <form @submit.prevent="announcementStore.post()" class="card py-4">
        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.bell.announcements.column_name }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="subject"
                        required
                        class="input"
                        v-model="announcementStore.record.name"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.bell.announcements.view_text_triggered_on }} 
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="subject"
                        class="input"
                        v-model="announcementStore.record.base_path"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{translations.bell.announcements.column_message}}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <editor-rich-text mode="small" v-model="announcementStore.record.message"></editor-rich-text>
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">{{translations.bell.announcements.column_start_at}}</label>
            </div>
            <div class="column">
                <input class="input is-info" type="date" v-model="announcementStore.record.start_at" @change="updateDates">
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">{{translations.bell.announcements.column_end_at}}</label>
            </div>
            <div class="column">
                <input class="input is-info" type="date" v-model="announcementStore.record.end_at" @change="updateDates">
            </div>
        </div>


        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{translations.bell.announcements.column_kind}}
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <lesli-select
                        v-model = "announcementStore.record.category"
                        :options="selectOptions">
                    </lesli-select>
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{translations.bell.announcements.column_can_be_closed}}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <label :for="option.label" class="radio" v-for="option in closeOptions" :key="option">
                    <input name="user_salutation" type="radio" :id="option.label" :value="option.value" v-model="announcementStore.record.can_be_closed" required/>
                    {{option.label}}
                </label>  
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.bell.notifications.view_text_receiver_users }}
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <lesli-input-tag
                        v-model="announcementStore.receiverUsers"
                        :placeholder="translations.core.shared.view_placeholder_search"
                        :options="announcementStore.users"
                        :filterFields="['name', 'email']"
                        showField="email"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.bell.notifications.view_text_receiver_roles }}
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <lesli-input-tag
                        v-model="announcementStore.receiverRoles"
                        :placeholder="translations.core.shared.view_placeholder_search"
                        :options="announcementStore.roles"
                        :filterFields="['name']"
                        showField="name"
                    />
                </div>
            </div>
        </div>

        <div class="px-3 ql-bg-blue">
            <button
                type="submit"
                class="button is-fullwidth has-text-centered submit-button is-primary"
            >
                {{ translations.core.shared.view_btn_save }}
            </button>
        </div>
    </form>
</template>
