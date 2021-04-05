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


import componentRichtextEditor from "LesliVue/components/editors/richtext.vue"


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
        "component-richtext-editor": componentRichtextEditor
    },
    data() {
        return {
        }
    },
    methods: {

        formSubmit() {
            if (this.announcement.id) {
                this.putAnnouncement()
            } else {
                this.postAnnouncement()
            }
        },

        postAnnouncement() {
            this.http.post(this.url.bell("announcements"), {
                announcement: this.announcement
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success("Announcement created successfully") 
            })
        },

        putAnnouncement() {
            this.http.put(this.url.bell("announcements/:id", { id: this.announcement.id }), {
                announcement: this.announcement
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.success("Announcement updated successfully") 
            })
        }

    }
}
</script>
<template>
    <form @submit.prevent="formSubmit()">
        <div class="field">
            <label class="label">Name</label>
            <div class="control">
                <input class="input" type="text" placeholder="Text input" v-model="announcement.name">
            </div>
        </div>

        <b-field grouped>
            <b-field label="category">
                <b-select>
                    <option>normal</option>
                    <option>info</option>
                    <option>success</option>
                    <option>warning</option>
                    <option>danger</option>
                </b-select>
            </b-field>
            <b-field label="expiration date">
               
            </b-field>
            <b-field label="can be closed?">
                <b-select>
                    <option>yes</option>
                    <option>no</option>
                </b-select>
            </b-field>
        </b-field>

        <div class="field">
            <label class="label">Message</label>
            <div class="control">
                <component-richtext-editor mode="simple" v-model="announcement.message"></component-richtext-editor>
            </div>
        </div>


        <div class="field is-grouped">
            <div class="control">
                <input type="submit" class="button is-link" value="submit" />
            </div>
        </div>

    </form>
</template>
