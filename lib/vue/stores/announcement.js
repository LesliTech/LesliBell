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
import { useRouter } from 'vue-router'


// ·
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.announcements")
    }
}


export const useBellAnnouncement = defineStore("bell.Announcement", {
    state: () => {
        return {
            announcements: { 
                pagination: {},
                records: []
            },

            router: useRouter(),
            loading: false,
            users: [],
            roles: [],
            filteredUsers: [],
            filteredRoles: [],
            record: {
                name: null,
                category: null,
                url: null,
                base_path: null,
                message: null,
                status: null,
                start_at: null,
                end_at: null,
                can_be_closed: null,
            },
            receiverUsers: [],
            receiverRoles: [],
            records: [],
            pagination: {
                page: 1
            },
            index: { 
                pagination: {},
                records: []
            }
        }
    },
    actions: {

        paginate(page) {
            this.announcements.pagination.page = page
            this.fetch()
        },

        fetch() {
            this.http.get(
                this.url.bell("announcements")
                .paginate(this.announcements.pagination.page)
            ).then(result => {
                this.announcements = result
            }).catch(error => {
                console.log(error)
            })
        },

        post() {
            this.loading = true
            this.http.post(this.url.bell("announcements"), {
                announcement: {
                    ...this.record,
                    user_receiver_emails: this.receiverUsers.map(user => user.email),
                    role_receiver_names: this.receiverRoles.map(role => role.name),
                }
            }).then(() => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.router.push(this.url.bell("announcements").s)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.record = {}
                this.receiverUsers = []
                this.receiverRoles = []
                this.loading = false
            })
        },

        getUsers() {
            this.loading = true
            this.http.get(this.url.admin('users/list')).then(result => {
                this.users = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        getRoles() {
            this.loading = true
            this.http.get(this.url.admin('roles/list')).then(result => {
                this.roles = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },
    }
})
