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
            announcement_id: null,
            announcement: {}
        }
    },
    mounted() {
        this.announcement_id = this.$route.params.id
        this.getAnnouncement()
    },
    methods: {

        getAnnouncement() {
            this.http.get(this.url.bell("announcements/:id", { id: this.announcement_id })).then(result => {
                this.announcement = result.data
            })
        }

    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="New announcement"></component-header>
        <div class="card">
            <div class="card-content">
                <component-form :announcement="this.announcement"></component-form>
            </div>
        </div>
    </section>
</template>
