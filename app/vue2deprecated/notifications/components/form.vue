<script>
/*
Copyright (c) 2020, all rights reserved.

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

// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


// ·
export default {
    components: {},
    data() {
        return {
            notification: {},
            options: null,
            users: null,
            roles: null,
            receiver_users: [],
            receiver_roles: [],
            filteredUsers: [],
            filteredRoles: [],
            submitting: false,
            translations: {
                core: {
                    shared: I18n.t("core.shared"),
                },
                bell: {
                    notifications: I18n.t("bell.notifications"),
                }
            },
        }
    },
    mounted() {
        this.getUsers()
        this.getRoles()
        this.getNotificationsOptions()
    },
    methods: {

        getUsers() {
            this.http.get(this.url.lesli('administration/users/list')).then(result => {
                if (result.successful) {
                    this.users = result.data
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getRoles() {
            this.http.get(this.url.lesli('administration/roles/list')).then(result => {
                if (result.successful) {
                    this.roles = result.data
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getFilteredUsers(text) {
            this.filteredUsers = this.users.filter((option) => {

                return (option.email||'').toString().toLowerCase().indexOf(text.toLowerCase()) >= 0 || (option.name||'').toString().toLowerCase().indexOf(text.toLowerCase()) >= 0
            })
        },

        getFilteredRoles(text) {
            this.filteredRoles = this.roles.filter((option) => {

                return (option.name||'').toString().toLowerCase().indexOf(text.toLowerCase()) >= 0
            })
        },

        getNotificationsOptions() {
            this.http.get(this.url.bell('notifications/options')).then(result => {
                if (result.successful) {
                    this.options = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        formSubmit() {
            this.submitting = true

            if (this.notification.id) {
                this.putNotification()
            } else {
                this.postNotification()
            }
        },

        postNotification() {
            this.http.post(this.url.bell("notifications"), {
                notification: {
                    ...this.notification,
                    user_receiver_emails: this.receiver_users.map(user => user.email),
                    role_receiver_names: this.receiver_roles.map(user => user.name),
                }
            }).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.bell.notifications.messages_success_notification_created_successfully)
                } else {
                    this.msg.error(result.error.message)
                }
            }).finally(() => {
                this.submitting = false
                this.notification = {}
                this.receiver_users = []
                this.receiver_roles = []
            })
        },

        putNotification() {
            this.http.put(this.url.bell("notifications/:id", { id: this.notification.id }), {
                notification: this.notification
            }).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.bell.notifications.messages_success_notification_updated_successfully)
                } else {
                    this.msg.error(result.error.message)
                }
            }).finally(() => {
                this.submitting = false
            })
        }

    },
    watch: {
        'data.notification': function(notification) {
            this.notification = notification
        }
    },
}
</script>
<template>
    <form @submit.prevent="formSubmit()">

        <fieldset :disabled="submitting">

            <b-field>
                <template v-slot:label>
                    {{ translations.bell.notifications.column_subject }} <sup class="has-text-danger">*</sup>
                </template>
                <b-input type="text" required v-model="notification.subject"></b-input>
            </b-field>

            <b-field>
                <template v-slot:label>
                    {{ translations.bell.notifications.column_body }}
                </template>
                <b-input type="textarea" maxlength="500" v-model="notification.body"></b-input>
            </b-field>

            <b-field>
                <template v-slot:label>
                    {{ translations.bell.notifications.column_url }}
                </template>
                <b-input type="text" v-model="notification.url"></b-input>
            </b-field>

            <b-field grouped>
                <b-field>
                    <template v-slot:label>
                        {{ translations.bell.notifications.column_status }}
                    </template>
                    <b-input type="text" v-model="notification.status" disabled></b-input>
                </b-field>

                <b-field>
                    <template v-slot:label>
                        {{ translations.bell.notifications.column_notification_type }}
                    </template>
                    <b-input type="text" v-model="notification.notification_type"></b-input>
                </b-field>

                <b-field>
                    <template v-slot:label>
                        {{ translations.bell.notifications.column_category }}
                    </template>
                    <div class="columns">
                        <div class="column is-12">
                            <b-select
                                v-if="options"
                                :placeholder="translations.core.shared.view_placeholder_select_option"
                                expanded
                                v-model="notification.category"
                            >
                                <option
                                    v-for="category in options.categories"
                                    :key="category.value"
                                    :value="category.value"
                                >
                                    {{ object_utils.translateEnum(translations.bell.notifications, 'column_enum_category', category.text) }}
                                </option>
                            </b-select>
                        </div>
                        <div class="column">
                            <b-button :type="`is-${notification.category}`">
                                <span>
                                    <b-icon icon="fa-brush" size="is-small"></b-icon>
                                </span>
                            </b-button>
                        </div>
                    </div>
                </b-field>
            </b-field>

            <b-field grouped>
                <b-field :label="translations.bell.notifications.view_text_receiver_users" :message="translations.bell.notifications.view_text_leave_empty_for_self_notification">
                    <b-taginput
                        v-model="receiver_users"
                        :data="filteredUsers"
                        autocomplete
                        field="email"
                        :open-on-focus="true"
                        icon="user"
                        :placeholder="translations.core.shared.view_placeholder_search"
                        @typing="getFilteredUsers"
                    >
                        <template v-slot="props">
                            <strong> {{ props.option.email }} </strong>
                            <template v-if="props.option.name != null">
                                : {{ props.option.name }}
                            </template>
                        </template>
                        <template #empty>
                            {{ translations.bell.notifications.view_text_email_not_found }}
                        </template>
                    </b-taginput>
                </b-field>

                <b-field :label="translations.bell.notifications.view_text_receiver_roles" :message="translations.bell.notifications.view_text_leave_empty_for_self_notification">
                    <b-taginput
                        v-model="receiver_roles"
                        :data="filteredRoles"
                        autocomplete
                        field="name"
                        :open-on-focus="true"
                        icon="fas fa-shield-alt"
                        :placeholder="translations.core.shared.view_placeholder_search"
                        @typing="getFilteredRoles"
                    >
                        <template v-slot="props">
                            <strong> {{ props.option.name }} </strong>
                        </template>
                        <template #empty>
                            {{ translations.bell.notifications.view_text_role_not_found }}
                        </template>
                    </b-taginput>
                </b-field>
            </b-field>

            <div class="buttons">
                <b-button name="submit-button" type="is-primary" expanded native-type="submit" class="submit-button">
                    <span v-if="submitting">
                        <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                        &nbsp;
                        {{ translations.core.shared.view_btn_saving }}
                    </span>
                    <span v-else>
                        {{ translations.core.shared.view_btn_save }}
                    </span>
                </b-button>
            </div>

        </fieldset>
    </form>
</template>
