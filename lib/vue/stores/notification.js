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
import { defineStore } from "pinia"

export const useBellNotification = defineStore("bell.Notification", {
    state: () => {
        return {
            loading: false,
            users: [],
            roles: [],
            filteredUsers: [],
            filteredRoles: [],
            record: {
                subject: null,
                body: null,
                url: null,
                status: null,
                notification_type: null,
                category: null,
            },
            receiverUsers: [],
            receiverRoles: [],
            pagination: {},
            records: []
        }
    },
    actions: {
        /**
        * @description This action is used to add pagination to notification index
        * @param {Integer} page the actual page showing in the index
        */
        paginate(page) {
            this.pagination.page = page
            this.fetch()
        },
        /**
        * @description This action is used to fetch all notifications
        */
        fetch() {
            this.http.get(
                this.url.bell("notifications").paginate(this.pagination.page)
            ).then(result => {
                this.pagination = result.pagination
                this.records = result.records
            })
        },
        /**
        * @description This action is used to create a new notification
        */
        async createNotification() {
            this.loading = true
            this.msg.info(I18n.t("bell.notifications.messages_info_creating_notifications"))
            return this.http.post(this.url.bell("notifications"), {
                notification: {
                    ...this.record,
                    user_receiver_emails: this.receiverUsers.map(user => user.email),
                    role_receiver_names: this.receiverRoles.map(role => role.name),
                }
            }).then(() => {
                this.msg.success(I18n.t("bell.notifications.messages_success_notification_created_successfully"))
            }).catch(error => {
                this.msg.danger(error)
            }).finally(() => {
                this.record = {}
                this.receiverUsers = []
                this.receiverRoles = []
                this.loading = false
            })
        },
        /**
        * @description This action is used to get the list of users for showing them on the autocomplete field in the form
        */
        getUsers() {
            this.loading = true
            this.http.get(this.url.admin('users/list')).then(result => {
                this.users = result
            }).catch(error => {
                this.msg.danger(error)
            }).finally(() => {
                this.loading = false
            })
        },
        /**
        * @description This action is used to get the list of roles for showing them on the autocomplete field in the form
        */
        getRoles() {
            this.loading = true
            this.http.get(this.url.admin('roles/list')).then(result => {
                this.roles = result
            }).catch(error => {
                this.msg.danger(error)
            }).finally(() => {
                this.loading = false
            })
        },

    }
})
