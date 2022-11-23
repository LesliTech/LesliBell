=begin

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

=end

require "lesli_request_helper"

RSpec.describe 'GET:/bell/announcements/list.json', type: :request do
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

    it 'is expected to respond with all the announcements that doesnt have base_path' do
        get '/bell/announcements/list.json'

        puts 'test 1'

        puts response_body

        # shared examples
        expect_response_with_successful
    end


    it 'is expected to respond with all the announcements' do
        get '/bell/announcements/list.json?f[base_path]=/'

        # shared examples
        expect_response_with_successful

        # custom specs
        puts 'test'

        puts response_body
        puts response_json

        expect(@response_body_data).to be_a(Object)
        expect(response_body[0]).to be_a(Object)

        expect(response_body.first).to have_key("id")
        expect(response_body.first["id"]).to be_a(Integer)

        expect(response_body.first).to have_key("name")
        expect(response_body.first["name"]).to be_a(String)

        expect(response_body.first).to have_key("category")
        expect(response_body.first["category"]).to be_a(String)

        expect(response_body.first).to have_key("can_be_closed")
        expect(response_body.first["can_be_closed"]).to be_in([true, false])

        expect(response_body.first).to have_key("message")
        expect(response_body.first["message"]).to be_a(String)

        expect(response_body.first).to have_key("start_at")
        expect(response_body.first["start_at"]).to be_a(String)

        expect(response_body.first).to have_key("end_at")
        expect(response_body.first["end_at"]).to be_a(String)

        expect(response_body.first).to have_key("base_path")
        expect(response_body.first["base_path"]).to be_a(String)

        
    end

end

