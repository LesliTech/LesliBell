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


RSpec.describe "PUT:/bell/announcements/:id", type: :request do
    include_context 'user authentication'
    
    before(:all) do
        @new_attributes = {
            "name" => Faker::Name.name,
            "status" => Faker::Boolean.boolean,
            "can_be_closed" => Faker::Boolean.boolean   
        }
        
        @announcement = @user.account.bell.announcements.first 
                
        put("/bell/announcements/#{@announcement.id}.json", params: {
            announcement: @new_attributes
        })
    end

    include_examples 'successful standard json response'


    it 'is expected to update an announcement' do                
        expect(@response_body["data"]["id"]).to eql(@announcement.id)
        expect(@response_body["data"]["name"]).to eql(@new_attributes["name"])
        expect(@response_body["data"]["status"]).to eql(@new_attributes["status"])
        expect(@response_body["data"]["can_be_closed"]).to eql(@new_attributes["can_be_closed"])
    end    
end

