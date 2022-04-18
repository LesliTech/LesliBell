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
    
    it 'is expected to respond with all the announcements' do
        get '/bell/announcements.json' 

        # shared examples
        expect_json_response_successful

        # custom specs
        expect(response_json["successful"]).to eql(true)
        expect(response_data["pagination"]["count_total"]).to eql(@current_user.account.bell.announcements.count)
    end 
end
