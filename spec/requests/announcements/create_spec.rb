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

        announcement_params = {
            name: "General Information",
            message: "<div><strong>hola</strong></div>",
            start_at: "2021-07-22T19:13:31.450Z",
            end_at: "2021-07-23T19:13:33.431Z",
            category: "success",
            can_be_closed: true,
            base_path: "/crm/",
            status: true
        }

        post("/bell/announcements.json", params: {
            announcement: announcement_params
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_json["id"]).to be > 0

        announcement = CloudBell::Announcement.find(response_json["id"])

        expect(announcement_params[:name]).to eql(announcement.name)
        expect(announcement_params[:message]).to eql(announcement.message)
        expect(announcement_params[:category]).to eql(announcement.category)
        expect(announcement_params[:can_be_closed]).to eql(announcement.can_be_closed)
        expect(announcement_params[:base_path]).to eql(announcement.base_path)

    end

    it "is expected to create a new announcement with minimum data" do
        post("/bell/announcements.json", params: {
            announcement: {
                name: "General Information",
                message: "<div><strong>hola</strong></div>"
            }
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_json["id"]).to be > 0

    end

end
