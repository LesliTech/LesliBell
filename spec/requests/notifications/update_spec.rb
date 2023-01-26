=begin
Copyright (c) 2023, all rights reserved.

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


# include helpers, configuration & initializers for request tests
require "lesli_request_helper"


RSpec.describe "PUT:/bell/notifications/:id", type: :request do

    include_context "request user authentication"

    # test cases
    it "is expected to update a notification" do

        notification = FactoryBot.create(:cloud_bell_notification)
        # update params
        notification_params = {
            subject: Faker::Lorem.sentence(word_count: 3),
            body: Faker::Lorem.sentence(word_count: 6),
        }

        put("/bell/notifications/#{notification.id}.json", params: { notification: notification_params}  )

        # shared examples
        expect_response_with_successful

        # specific tests for the response
        expect(response_body).to have_key("subject")
        expect(response_body["subject"]).to eql(notification_params[:subject])

        expect(response_body).to have_key("body")
        expect(response_body["body"]).to eql(notification_params[:body])
    end

    it "is expected to receive a response with an error if no params are sent" do

        notification = FactoryBot.create(:cloud_bell_notification)
        
        put("/bell/notifications/#{notification.id}.json", params: {}  )

        # shared examples
        expect_response_with_error

    end

end