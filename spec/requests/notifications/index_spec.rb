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


# include helpers, configuration & initializers for request tests
require 'lesli_request_helper'

#
RSpec.describe 'GET:/bell/notifications.json', type: :request do
    include_context 'request user authentication'

    it 'is expected to respond with all the notification for the current user' do

        get('/bell/notifications.json')

        # shared examples
        expect_response_with_successful


        # custom

        notification_index = CloudBell::Notification.index(@current_user, @query)
        notification_result = @current_user.account.bell.notifications.where(:user => @current_user).count

        expect(response_json['pagination']['count_total']).to eql(notification_result)
        expect(response_json['pagination']['count_results']).to eql(response_json['records'].size)
        expect(response_json['pagination']['count_results']).to be <= @query[:pagination][:perPage]
    end
end
