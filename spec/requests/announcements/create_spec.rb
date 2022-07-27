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

RSpec.describe 'POST:/bell/announcements', type: :request do
    include_context "request user authentication"

    it "is expected to create a new announcement" do
        post("/bell/announcements.json", params: {
            announcement: {
                base_path: "/crm/",
                can_be_closed: true,
                category: "success",
                end_at: "2021-07-23T19:13:33.431Z",
                message: "{\"delta\":{\"ops\":[{\"insert\":\"Testing announcements\\n\"}]},\"html\":\"<p>Testing announcements</p>\"}",
                name: "General Information",
                start_at: "2021-07-22T19:13:31.450Z",
                status: true
            }
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_json["id"]).to be > 0
    end
end
