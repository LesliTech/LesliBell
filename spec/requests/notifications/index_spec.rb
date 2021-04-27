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


RSpec.describe 'GET:/bell/notifications.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do
        get '/bell/notifications.json' 
    end

    include_examples 'successful standard json response'

    it 'is expected to respond with all the notification for the current user' do
        notifications = Courier::Bell::Notification.index(@user, { pagination: { page: 1, perPage: 999 }})
        notifications = notifications[:pagination][:count_results]
        expect(@response_body["data"]["pagination"]["count_results"]).to eql(notifications)
    end
    
end
