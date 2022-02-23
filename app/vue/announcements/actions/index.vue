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
            columns: [{
                field: 'id',
                label: 'ID',
                width: '40',
                numeric: true
            }, {
                field: 'name',
                label: 'Name',
            }]
        }
    },
    mounted() {
        this.getAnnouncements()
    },
    methods: {

        viewAnnouncement(announcement) {
            this.$router.push(`announcements/${announcement.id}/edit`)
        },

        getAnnouncements() {
            this.http.get(this.url.bell("announcements").paginate(1)).then(result => {
                this.announcements = result.data
            })
        },

        deleteAnnouncement(announcement_id){
            let url = this.url.bell('announcements/:id', {id: announcement_id})

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.announcements.records = this.announcements.records.filter(e => e.id !== announcement_id)
                    this.msg.success(this.translations.bell.announcements.messages_success_announcement_deleted_successfully)
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.bell.announcements.view_title_announcements">
            <div class="buttons">
                <router-link class="button" tag="button" to="announcements/list">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>{{ translations.core.shared.view_btn_list }}</span>
                </router-link>
                <router-link class="button" tag="button" to="announcements/new">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.bell.announcements.view_btn_new }}</span>
                </router-link>
            </div>
        </component-header>

        <b-table
            :hoverable="true"
            :data="announcements.records"
            @click="viewAnnouncement"
        >
            <template slot="empty">
                <component-data-empty></component-data-empty>
            </template>
            <template slot-scope="props">
                <b-table-column :label="translations.bell.announcements.column_id" sortable field="id">
                    {{ props.row.id }}
                </b-table-column>

                <b-table-column :label="translations.bell.announcements.column_name" sortable field="name">
                    {{ props.row.name }}
                </b-table-column>

                <b-table-column :label="translations.bell.announcements.column_kind" sortable field="category">
                    {{ props.row.category }}
                </b-table-column>

                <b-table-column :label="translations.core.shared.view_text_actions" sortable field="actions">
                    <span>
                        <b-button type="is-danger" outlined @click.stop="deleteAnnouncement(props.row.id)">
                            <b-icon icon="trash-alt" size="is-small" />
                        </b-button>
                    </span>
                </b-table-column>
            </template>
        </b-table>
    </section>
</template>
