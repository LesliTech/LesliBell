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


// · 
export default {
    data() {
        return {
            translations: {
                core: {
                    shared: I18n.t("core.shared"),
                },
                bell: {
                    notifications: I18n.t("bell.notifications"),
                }
            },
            columns: [{
                field: 'id',
                label: 'ID',
                width: '40',
                numeric: true
            }, {
                field: 'subject',
                label: 'Notification',
            }, {
                field: 'body',
                label: ''
            }, {
                field: 'created_at',
                label: 'Created at'
            }],
            notifications: [],
        }
    },
    mounted() {
        this.getNotifications()
    },
    methods: {

        getNotifications() {
            this.http.get(this.url.bell("notifications")).then(result => {
                this.notifications = result.data
            })
        },
        testNotification() {
            this.http.post(this.url.bell("notifications"), {
                notification: {
                    subject: 'test'
                }
            }).then(result => {
                this.msg.info(translations.bell.notifications.messages_info_notification_test_sent)
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.bell.notifications.view_title_notifications">
            <div class="buttons">
                <button class="button is-primary" @click="testNotification()">test</button>
            </div>
        </component-header>

        <div class="box">
        <b-table 
            v-if="notifications.records" 
            :row-class="(row, index) => `message is-${ row.category }`"
            :data="notifications.records" 
            :columns="columns">
        </b-table>
        </div> 
    </section>
</template>
