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


RSpec.describe "PUT:/bell/notifications/:id.json", type: :request do
    include_context 'user authentication'
    
    before(:all) do

        # register a notification to the user, so we have at least one active notification
        @notification = Courier::Bell::Notification.new(@user, "notification from rspec")

        # mark notification as read
        put "/bell/notifications/#{ @notification[:id] }.json"

    end

    include_examples 'successful standard json response'

    it 'is expected to respond with notification id marked as read' do
        expect(@response_body["data"]["id"]).to eql(@notification[:id])
    end
end
