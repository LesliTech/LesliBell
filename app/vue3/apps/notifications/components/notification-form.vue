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
import { onMounted, inject } from "vue"

// · import store
import { useBellNotification } from "CloudBell/stores/notification"

// · import vue router composable
import { useRouter, useRoute } from "vue-router"

// · implement store
const notificationStore = useBellNotification()

// . Defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.notifications")
    }
}

// · initialize/inject plugins
const router = useRouter()

// · initializing
onMounted(() => {
    notificationStore.getUsers()
    notificationStore.getRoles()
})

/**
 * @description This function is used to create a new notification
 */
const onCreate = () => {
    notificationStore.createNotification().then(() => {
        router.push(notificationStore.url.bell('notifications').toString())
    })
}

</script>

<template>
    <lesli-loading v-if="notificationStore.loading"></lesli-loading>
    <form @submit.prevent="onCreate" class="card py-4" v-else>
        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.bell.notifications.column_subject }}
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
                        v-model="notificationStore.record.subject"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.bell.notifications.column_body }}
                </label>
            </div>
            <div class="column">
                <textarea
                    name="body"
                    rows="3"
                    maxlength="500"
                    class="textarea"
                    v-model="notificationStore.record.body"
                ></textarea>
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
                        v-model="notificationStore.receiverUsers"
                        :placeholder="translations.core.shared.view_placeholder_search"
                        :options="notificationStore.users"
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
                        v-model="notificationStore.receiverRoles"
                        :placeholder="translations.core.shared.view_placeholder_search"
                        :options="notificationStore.roles"
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
