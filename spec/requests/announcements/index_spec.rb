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

RSpec.describe 'GET:/bell/announcements.json', type: :request do
    include_context "request user authentication"

    let!(:new_announcement) do

        announcement_params =  {
            base_path: "/",
            can_be_closed: true,
            category: "success",
            end_at: "2021-07-23T19:13:33.431Z",
            message: { html:"<p>Testing announcements</p>" },
            name: "General Information",
            start_at: "2021-07-22T19:13:31.450Z",
            status: true
        }    

        announcement = @current_user.account.bell.announcements.new(announcement_params)
        announcement.user = @current_user
        announcement.save!
        announcement
    end

    it 'is expected to respond with all the announcements' do
        get '/bell/announcements.json'

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_json["pagination"]["total"]).to eql(@current_user.account.bell.announcements.count)

        expect(@response_body_data).to be_a(Object)
        expect(response_body["records"][0]).to be_a(Object)

        expect(response_body["records"][0]).to have_key("id")
        expect(response_body["records"][0]["id"]).to be_a(Integer)

        expect(response_body["records"][0]).to have_key("category")
        expect(response_body["records"][0]["category"]).to be_a(String)

        expect(response_body["records"][0]).to have_key("status")
        expect(response_body["records"][0]["status"]).to be_in([true, false])

        expect(response_body["records"][0]).to have_key("can_be_closed")
        expect(response_body["records"][0]["can_be_closed"]).to be_in([true, false])

        expect(response_body["records"][0]).to have_key("message")
        expect(response_body["records"][0]["message"]).to be_a(Object)

        
    end
end
