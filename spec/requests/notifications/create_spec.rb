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


require 'rails_helper'
require 'spec_helper'
require 'byebug'


[{
    "id": 23,
    "subject": "New notification created",
    "body": nil,
    "kind": nil,
    "url": "/bell",
}, {
    "subject": "New notification created",
    "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "kind": "danger",
    "url": "/bell"
}, {
    "subject": "New notification created",
    "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "kind": "warning",
    "url": "/bell"
}, {
    "subject": "New notification created",
    "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "kind": "success",
    "url": "/bell"
}, {
    "subject": "New notification created",
    "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "kind": "info",
    "url": "/bell"
}].each do |notification|

    RSpec.describe 'POST:/bell/notifications', type: :request do
        include_context 'user authentication'

        before(:all) do
            #notification[:users_id] = @user.id
            post("/bell/notifications.json", params: {
                notification: notification
            })
        end

        include_examples 'successful standard json response'

        it 'is expected to create a new notification' do
            #expect(@response_body["data"]["id"]).to be > 0
        end

    end

end
