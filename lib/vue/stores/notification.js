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


// · 
import { defineStore } from "pinia"


// · 
export const useBellNotification = defineStore("bell.Notification", {
    state: () => {
        return {
            index: {
                loading: false,
                records: [],
                pagination: {}
            },


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

        paginate(page) {
            this.pagination.page = page
            this.fetch()
        },

        fetch() {
            if (this.index.records.length <= 0) {
                this.get()
            }
        },

        get() {
            this.index.loading = true
            let url = this.url.bell("notifications").paginate(this.pagination.page)

            this.http.get(url).then(result => {
                this.index.pagination = result.pagination
                this.index.records = result.records
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.index.loading = false
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
