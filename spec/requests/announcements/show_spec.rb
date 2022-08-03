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

RSpec.describe 'GET:/bell/announcements/:id.json', type: :request do
    include_context "request user authentication"

    let!(:create_new_announcement) do
        new_announcement =  @current_user.account.bell.announcements.new(
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

    it 'is expected to respond with the announcement requested' do
        announcement = create_new_announcement

        get "/bell/announcements/#{announcement.id}.json"

        # shared examples
        expect_response_with_successful

        # custom specs
        announcement.attributes.except("created_at", "updated_at").each do |key, value|
            if (value.is_a?(Time))
                expect(LC::Date.datetime(response_json[key])).to eql(LC::Date.datetime(value))
            else
                expect(response_json[key]).to eql(value)
            end
        end
    end
end
