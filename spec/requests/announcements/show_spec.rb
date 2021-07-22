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


RSpec.describe 'GET:/bell/announcements/:id.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do
        @announcement = @user.account.bell.announcements.first
                
        get "/bell/announcements/#{@announcement.id}.json" 
    end

    include_examples 'successful standard json response'

    it 'is expected to respond with the announcement requested' do        
        @announcement.attributes.except("created_at", "updated_at").each do |key, value|      
            if (value.is_a?(Time))                
                expect(LC::Date.datetime(@response_body["data"][key])).to eql(LC::Date.datetime(value))
            else
                expect(@response_body["data"][key]).to eql(value)  
            end
        end
    end
end
