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
            translations: {},
            announcements: [],
        }
    },
    mounted() {
        this.getAnnouncements()
    },
    methods: {
        getAnnouncements() {
            this.http.get(this.url.bell("announcements").paginate(1)).then(result => {
                this.announcements = result.data
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Announcements">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>List announcements</span>
                </router-link>
                <router-link class="button" tag="button" to="/new">
                    <b-icon icon="plus" size="is-small" />
                    <span>New announcements</span>
                </router-link>
            </div>
        </component-header>
        <div class="card">
            <component-data-empty v-if="announcements.pagination.count_total <= 0"></component-data-empty>
            <div class="card-content" v-if="announcements.pagination.count_total > 0">
                <div :class="['message', 'is-'+announcement.kind]" v-for="announcement in announcements.records" :key="announcement.id">
                    <div class="message-body">
                        {{ announcement.name }}
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
