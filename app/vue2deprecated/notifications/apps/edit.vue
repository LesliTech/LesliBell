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
import componentForm from "../components/form.vue"


// · 
export default {
    components: {
        "component-form": componentForm
    },
    data() {
        return {
            notification_id: null,
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
        this.notification_id = this.$route.params.id
        this.getNotification()
    },
    methods: {

        getNotification() {
            this.http.get(this.url.bell("notifications/:id", { id: this.notification_id })).then(result => {
                if (result.successful) {
                    this.data.notification = result.data
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.bell.notifications.view_title_edit_notification"></component-header>
        <div class="card">
            <div class="card-content">
                <component-form></component-form>
            </div>
        </div>
    </section>
</template>
