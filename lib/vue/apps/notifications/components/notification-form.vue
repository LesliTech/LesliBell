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
import { onMounted, inject } from "vue"


// · import store
import { useBellNotification } from "LesliBell/vue/stores/notification"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement store
const notificationStore = useBellNotification()


// . Defining translations
const translations = {
    lesli: {
        shared: i18n.t("lesli.shared")
    },
    bell: {
        notifications: i18n.t("lesli_bell.notifications")
    },

    core: {
        shared: I18n.t("core.shared")
    }
}


// · initialize/inject plugins
const router = useRouter()


// · initializing
onMounted(() => {
    notificationStore.getUsers()
    notificationStore.getRoles()
})


// · 
function onCreate() {
    notificationStore.createNotification().then(() => {
        router.push(notificationStore.url.bell('notifications').toString())
    })
}

</script>
<template>
    <lesli-form @submit="onCreate">
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
                {{ translations.lesli.shared.button_save }}
            </button>
        </div>
    </lesli-form>
</template>
