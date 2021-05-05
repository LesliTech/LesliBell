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
                    announcements: I18n.t("bell.announcements"),
                }
            },
            announcements: {
                pagination: {}
            },
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
        <component-header :title="translations.bell.announcements.view_title_announcements">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>{{ translations.core.shared.view_btn_list }}</span>
                </router-link>
                <router-link class="button" tag="button" to="/new">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.bell.announcements.view_btn_new }}</span>
                </router-link>
            </div>
        </component-header>
        <div class="box">
            <component-data-empty v-if="announcements.pagination.count_total <= 0"></component-data-empty>
            <a :href="url.bell('announcements/:id/edit', { id: 1 })">
                <b-notification 
                    v-for="announcement in announcements.records" 
                    :key="announcement.id" 
                    type="is-info">
                    <div v-html="announcement.message.html">
                    </div>
                </b-notification>
            </a>
        </div>
    </section>
</template>
