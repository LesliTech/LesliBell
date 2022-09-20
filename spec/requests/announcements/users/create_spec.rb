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


RSpec.describe "POST:/bell/announcements/:id/users.json", type: :request do
    include_context "request user authentication"

    let!(:new_announcement) do

        announcement_params =  {
            base_path: "/",
            can_be_closed: true,
            category: "success",
            end_at: "2021-07-23T19:13:33.431Z",
            message: "{\"delta\":{\"ops\":[{\"insert\":\"Testing announcements\\n\"}]},\"html\":\"<p>Testing announcements</p>\"}",
            name: "General Information",
            start_at: "2021-07-22T19:13:31.450Z",
            status: true
        }    

        announcement = @current_user.account.bell.announcements.new(announcement_params)
        announcement.user = @current_user
        announcement.save!
        announcement
    end
    
    # test cases
    
    it "is expected to test the creation of the record" do

        post("/bell/announcements/#{new_announcement.id}/users.json", params: {
            announcement_user:{
                status: 'closed'
            }
        })
        # shared examples
        expect_response_with_successful

        expect(response_body).to be_a(Object)

        expect(response_body).to have_key("id")
        expect(response_body["id"]).to be_a(Integer)

        expect(response_body).to have_key("status")
        expect(response_body["status"]).to be_a(String)
        expect(response_body["status"]).to eql("closed")

        expect(response_body).to have_key("cloud_bell_announcements_id")
        expect(response_body["cloud_bell_announcements_id"]).to be_a(Integer)
        expect(response_body["cloud_bell_announcements_id"]).to eql(new_announcement.id)

        expect(response_body).to have_key("users_id")
        expect(response_body["users_id"]).to be_a(Integer)
        expect(response_body["users_id"]).to eql(@current_user.id)

    end
end
