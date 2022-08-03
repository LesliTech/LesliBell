=begin

Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end


require "lesli_request_helper"

RSpec.describe "PUT:/bell/announcements/:id", type: :request do
    include_context "request user authentication"

    let!(:create_new_announcement) do
        new_announcement =  @current_user.account.bell.announcements.create(
            base_path: "/crm/",
            can_be_closed: true,
            category: "success",
            end_at: "2021-07-23T19:13:33.431Z",
            message: "{\"delta\":{\"ops\":[{\"insert\":\"Testing announcements\\n\"}]},\"html\":\"<p>Testing announcements</p>\"}",
            name: "General Information",
            start_at: "2021-07-22T19:13:31.450Z",
            status: true
        )
        new_announcement.user = @current_user
        new_announcement.save()
        new_announcement
    end

    it 'is expected to update an announcement' do
        create_new_announcement
        @new_attributes = {
            "name" => Faker::Name.name,
            "status" => Faker::Boolean.boolean,
            "can_be_closed" => Faker::Boolean.boolean
        }

        @announcement = @current_user.account.bell.announcements.first

        put("/bell/announcements/#{@announcement.id}.json", params: {
            announcement: @new_attributes
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_json["id"]).to eql(@announcement.id)
        expect(response_json["name"]).to eql(@new_attributes["name"])
        expect(response_json["status"]).to eql(@new_attributes["status"])
        expect(response_json["can_be_closed"]).to eql(@new_attributes["can_be_closed"])
    end
end

