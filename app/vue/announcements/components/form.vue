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


import DatePicker from 'v-calendar/lib/components/date-picker.umd'
import componentRichtextEditor from 'LesliVue/components/editors/richtext.vue'
import componentRichTextEditor from 'LesliVue/components/forms/richtext-editor.vue'


// ·
export default {
    props: {
        announcement: {
            type: Object,
            default() {
                return {}
            }
        }
    },
    components: {
        'vc-date-picker': DatePicker,
        "component-richtext-editor": componentRichtextEditor,
        "component-rich-text-editor": componentRichTextEditor,
    },
    data() {
        return {
            options: null,
            message: {},
            richText: {
                delta: null,
                html: null
            },
            translations: {
                core: {
                    shared: I18n.t("core.shared"),
                },
                bell: {
                    announcements: I18n.t("bell.announcements"),
                }
            },
        }
    },
    mounted() {
        this.getAnnouncementOptions()
    },
    methods: {

        richTextHtml(html) {
            this.richText.html = html
        },

        richTextInput(delta) {
            this.richText.delta = delta
        },

        getAnnouncementOptions() {
            let url = this.url.bell('announcements/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        formSubmit() {
            if (this.announcement.id) {
                this.putAnnouncement()
            } else {
                this.postAnnouncement()
            }
        },

        postAnnouncement() {
            this.http.post(this.url.bell("announcements"), {
                announcement: {
                    ...this.announcement,
                    message: JSON.stringify(this.richText)
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success(this.translations.bell.announcements.messages_success_announcement_created_successfully)
            })
        },

        putAnnouncement() {
            this.http.put(this.url.bell("announcements/:id", { id: this.announcement.id }), {
                announcement: {
                    ...this.announcement,
                    message: JSON.stringify(this.richText)
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success(this.translations.bell.announcements.messages_success_announcement_updated_successfully)
            })
        }

    },
    watch: {
        'announcement'(announcement) {
            if (announcement.message) {
                this.message = JSON.parse(announcement.message).delta
            }
        }
    }
}
</script>
<template>
    <form @submit.prevent="formSubmit()">
        <b-field>
            <template v-slot:label>
                {{ translations.bell.announcements.column_name }} <sup class="has-text-danger">*</sup>
            </template>
            <b-input name="name" ref="announcement-name" type="text" placeholder="Text input" required v-model="announcement.name">
            </b-input>
        </b-field>

        <b-field grouped>
            <b-field
                :label="translations.bell.announcements.column_start_at"
            >
                <vc-date-picker
                    v-model="announcement.start_at"
                    :locale="date.vcDatepickerConfig()"
                    :popover="{ visibility: 'focus' }"
                    :min-date="announcement.id ? null : new Date()"
                >
                    <template v-slot="{ inputValue, inputEvents }">
                        <input
                            class="input is-default"
                            v-on="inputEvents"
                            :value="inputValue"
                            :placeholder="translations.core.shared.text_select_date"
                        />
                    </template>
                </vc-date-picker>
            </b-field>

            <b-field
                :label="translations.bell.announcements.column_end_at"
                :message="translations.bell.announcements.view_text_expiration_date_indefinite"
            >
                <vc-date-picker
                    v-model="announcement.end_at"
                    :locale="date.vcDatepickerConfig()"
                    :popover="{ visibility: 'focus' }"
                    :min-date="announcement.id ? null : new Date()"
                >
                    <template v-slot="{ inputValue, inputEvents }">
                        <input
                            class="input is-default"
                            v-on="inputEvents"
                            :value="inputValue"
                            :placeholder="translations.core.shared.text_select_date"
                        />
                    </template>
                </vc-date-picker>
            </b-field>

            <b-field :label="translations.bell.announcements.column_can_be_closed">
                <b-select v-model="announcement.can_be_closed">
                    <option value="true">{{ translations.core.shared.view_text_yes }}</option>
                    <option value="false">{{ translations.core.shared.view_text_no }}</option>
                </b-select>
            </b-field>
        </b-field>

        <b-field>
            <template v-slot:label>
                {{ translations.bell.announcements.column_kind }}<sup class="has-text-danger">*</sup>
            </template>
            <div class="columns">
                <div class="column is-4">
                    <b-select
                        v-if="options"
                        :placeholder="translations.core.view_placeholder_select_option"
                        required
                        expanded
                        v-model="announcement.category"
                    >
                        <option
                            v-for="category in options.categories"
                            :key="category.value"
                            :value="category.value"
                        >
                            {{ object_utils.translateEnum(translations.bell.announcements, 'column_enum_category', category.text) }}
                        </option>
                    </b-select>
                </div>
                <div class="column">
                    <b-button :type="`is-${announcement.category}`">
                        <span>
                            <b-icon icon="fa-brush" size="is-small"></b-icon>
                        </span>
                    </b-button>
                </div>
            </div>
        </b-field>

        <b-field>
            <template v-slot:label>
                {{ translations.bell.announcements.view_text_triggered_on }} <sup class="has-text-danger">*</sup>
            </template>
            <b-input type="text" :placeholder="translations.bell.announcements.view_text_base_path_placeholder" required v-model="announcement.base_path">
            </b-input>
        </b-field>

        <div class="field text-editor-container">
            <label class="label">{{ translations.bell.announcements.column_message }}</label>
            <div class="control">
                <component-rich-text-editor :value="message" @input="richTextInput" @html="richTextHtml" type="tiny"></component-rich-text-editor>
            </div>
        </div>


        <div class="field is-grouped">
            <div class="control">
                <input type="submit" class="button is-link" value="submit" />
            </div>
        </div>

    </form>
</template>
