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

// · import store
import { useBellAnnouncement } from "CloudBell/stores/announcement"

// · implement store
const announcementStore = useBellAnnouncement()

// . Defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.notifications")
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
                    Name
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
                    Url
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
                        v-model="announcementStore.record.url"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    Base path
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
                        v-model="announcementStore.record.base_path"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    Message
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
                        v-model="announcementStore.record.message"
                    />
                </div>
            </div>
        </div>


        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    Category
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
                        v-model="announcementStore.record.category"
                    />
                </div>
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


        <article :class="['message', `is-${announcementStore.record.category}`]">
            <div class="message-header">
                <p>{{announcementStore.record.name}}</p>
                <button class="delete" aria-label="delete" v-if="announcementStore.record.can_be_closed"></button>
            </div>
            <div class="message-body">
                {{announcementStore.record.message}}
            </div>
        </article>

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
