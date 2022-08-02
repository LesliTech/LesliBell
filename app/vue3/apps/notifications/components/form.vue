<script setup>
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

// · import vue tools
import { onMounted, ref, computed } from "vue"

// · import vue router composable
import { useRouter } from "vue-router"

// · import store
import { useBellNotification } from "CloudBell/stores/notification"

// · import url composable
import { useUrl } from "LesliVue/composables/url"

// · import msg composable
import { useMsg } from "LesliVue/composables/msg"

// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
})

// · implement store
const NotificationStore = useBellNotification()

// · implement url composable
const url = useUrl()

// · implement msg composable
const msg = useMsg()

// · implement router
const router = useRouter()

if (!props.isEditable) {

    // // · Clear values in the store if the form is not editable
    // Object.keys(projectStore.record).forEach(key => {
        
    //     const fieldToEvaluate = projectStore.record[key]
        
    //     // clear project field for creation, it depends on the field type
    //     if (typeof fieldToEvaluate === "boolean") projectStore.record[key] = false
    //     else projectStore.record[key] = null
        
    //     // special case for categories array
    //     if (key === "categories") projectStore.record[key] = []
        
    // })
}

/**
 * @param {*} id The id of the current project to update
 * @param {*} payload The payload to update the project with
 * @description This function is used to update the project with the given payload.
 */
const onUpdate = () => {

    // // · validate if categories are empty
    // if (project.value.categories.length === 0) {
    //     msg.warning(translations.core.shared.messages_warning_required_fields)
    //     return
    // }

    // projectStore.update()
}

/**
 * @param {*} payload The payload to create the project with
 * @description This function is used to create a new project with the given payload.
 */
const onCreate = () => {
    // projectStore.create()
    // router.push(url.mitwerken('admin/projects').toString())
}

// · initializing
onMounted(() => {
    // categoryStore.fetch()
})
</script>

<template>
    <form
        @submit.prevent="
            isEditable
                ? onUpdate()
                : onCreate()
        "
        class="card py-4"
    >
        <!-- <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_name }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="name"
                        required
                        class="input"
                        v-model="project.name"
                    />
                </div>
            </div>
        </div> -->

        <!-- <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_project_city }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="city"
                        required
                        class="input"
                        v-model="project.city"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_street }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="street"
                        required
                        class="input"
                        v-model="project.street"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">{{ translations.mitwerken.admin_projects.view_text_location_coordinates }}</label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="decimal"
                        autocomplete="on"
                        name="latitude"
                        required
                        class="input"
                        v-model="project.latitude"
                        :placeholder="translations.mitwerken.admin_projects.view_placeholder_latitude"
                    />
                </div>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        montieren
                        autocomplete="on"
                        name="longitude"
                        required
                        class="input"
                        v-model="project.longitude"
                        :placeholder="translations.mitwerken.admin_projects.view_placeholder_longitude"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_date }}
                </label>
            </div>
            <div class="column">
                <span>
                    <input
                        placeholder="Select a date"
                        required="required"
                        class="input is-default"
                        type="date"
                        v-model="project.start_at"
                    />
                </span>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label"> 
                    {{ translations.mitwerken.admin_projects.view_text_duration }}
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="duration"
                        class="input"
                        v-model="project.duration_in_hours"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label"> 
                    {{ translations.mitwerken.admin_projects.view_text_budget }}
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        name="budget"
                        class="input"
                        v-model="project.budget"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_hourly_wage_min }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        class="input"
                        v-model="project.hourly_wage_min"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_hourly_wage_max }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <input
                        type="text"
                        autocomplete="on"
                        class="input"
                        v-model="project.hourly_wage_max"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom" v-if="!categoryIsLoading" >
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_categories }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <div class="control is-clearfix">
                    <lesli-input-tag 
                        :placeholder="translations.mitwerken.admin_projects.view_placeholder_enter_category" 
                        :options="categories" 
                        v-model="project.categories"
                    />
                </div>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_tools_needed }}
                </label>
            </div>
            <div class="column">
                <label class="checkbox">
                    <input
                        type="checkbox"
                        name="tools-needed"
                        :true-value="true"
                        :value="false"
                        v-model="project.tools_needed"
                    />
                    <span class="check"></span>
                    <span class="control-label"></span>
                </label>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label"> {{ translations.mitwerken.admin_projects.view_text_is_insured }} </label>
            </div>
            <div class="column">
                <label class="checkbox">
                    <input
                        type="checkbox"
                        name="is-ensured"
                        :true-value="true"
                        :value="false"
                        v-model="project.is_insured"
                    />
                    <span class="check"></span>
                    <span class="control-label"></span>
                </label>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label"> 
                    {{ translations.mitwerken.admin_projects.view_text_has_material_available }} 
                </label>
            </div>
            <div class="column">
                <label class="checkbox">
                    <input
                        type="checkbox"
                        name="has-material-available"
                        :true-value="true"
                        :value="false"
                        v-model="project.has_material_available"
                    />
                    <span class="check"></span>
                    <span class="control-label"></span>
                </label>
            </div>
        </div>

        <div class="columns is-marginless has-border-bottom">
            <div class="column is-4">
                <label class="label">
                    {{ translations.mitwerken.admin_projects.view_text_description }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="column">
                <textarea
                    name="description"
                    required
                    rows="3"
                    maxlength="1000"
                    class="textarea"
                    v-model="project.description"
                ></textarea>
            </div>
        </div> -->
        <div class="px-3 ql-bg-blue">
            <button
                type="submit"
                class="button is-fullwidth has-text-centered submit-button is-primary"
            >
                {{ translations.core.shared.view_btn_save }}
            </button>
        </div>
    </form>
</template>
