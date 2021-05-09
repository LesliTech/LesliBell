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
            this.http.post(this.url.bell("notifications")).then(result => {
                
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.bell.notifications.view_title_notifications"></component-header>
        <div class="card">
            <div class="card-content">
                <button class="button is-primary" @click="testNotification()">test</button>
                <div 
                    v-for="notification in notifications.records" 
                    :key="notification.id"
                    :class="['message', 'is-'+notification.kind]">
                    <div class="message-body">
                        {{ notification.subject }}
                    </div>
                </div>
            </div>
        </div>
        
    </section>
</template>
