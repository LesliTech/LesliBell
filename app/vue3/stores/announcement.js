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
import { useRouter } from 'vue-router'

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

        /**
        * @description This action is used to add pagination to announcement index
        * @param {Integer} page the actual page showing in the index
        */
        paginate(page) {
            this.pagination.page = page
            this.fetch()
        },

        /**
         * @description This action is used to fetch all the announcements for the current user
         */
        fetch() {
            this.http.get(
                this.url.bell("announcements")
                .paginate(this.pagination.page)
            ).then(result => {
                this.pagination = result.pagination
                this.records = result.records
            })
        },

        /**
         * @description This action is used to create a new announcement
         */
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

        /**
        * @description This action is used to get the list of users
        */
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

        /**
        * @description This action is used to get the list of roles
        */
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
