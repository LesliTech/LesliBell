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


# include helpers, configuration & initializers for request tests
require 'lesli_request_helper'

RSpec.describe 'GET:/bell/notifications.json', type: :request do
    
    let(:create_notification){FactoryBot.create(:cloud_bell_notification)}
    
    include_context 'request user authentication'
    
    it 'is expected to respond with all the notification for the current user' do
        
        get('/bell/notifications.json')        
        
        # shared examples
        expect_response_with_successful
        
        # custom
        notification_index = CloudBell::Notification.index(@current_user, @query)
        notification_count = @current_user.account.bell.notifications.where(:user => @current_user, :status => ["created", "sent", nil]).count
        
        expect(response_json['pagination']['total']).to eql(notification_count)
        expect(response_json['pagination']['results']).to eql(response_json['records'].size)
        expect(response_json['pagination']['results']).to be <= @query[:pagination][:perPage]
    end
    
    it "is expect to have a valid pagination" do
        
        get('/bell/notifications.json')
        
        # shared examples
        expect_response_with_pagination
        
        # custom
        expect(response_json).to have_key("pagination")
        expect(response_json["pagination"]).to be_a(Hash)
        expect(response_json['pagination']).to have_key('page')
        expect(response_json["pagination"]['page']).to be_a(Numeric)
        expect(response_json['pagination']).to have_key('pages')
        expect(response_json["pagination"]['pages']).to be_a(Numeric)
        expect(response_json['pagination']).to have_key('total')
        expect(response_json["pagination"]['total']).to be_a(Numeric)
    end
    
    it "is expect to have a valid records" do
        
        new_notification = create_notification
        
        get('/bell/notifications.json')    
        
        # shared examples        
        expect_response_with_pagination
        
        # custom
        expect(response_json).to have_key("records")
        expect(response_json["records"]).to be_a(Array)
        expect(response_json["records"].first).to have_key('id')
        expect(response_json["records"].first['id']).to be > 0
        expect(response_json["records"].first['id']).to_not be(nil)
        expect(response_json["records"].first['id']).to be_a_kind_of(Integer)
        expect(response_json["records"].first).to have_key('subject')
        expect(response_json["records"].first['subject']).to_not be(nil)
        expect(response_json["records"].first['subject']).to be_a(String)
        expect(response_json["records"].first).to have_key('body')
        expect(response_json["records"].first['body']).to be_a(String)
        expect(response_json["records"].first).to have_key('url')
        expect(response_json["records"].first['url']).to be_a(String)
        expect(response_json["records"].first).to have_key('status')
        expect(response_json["records"].first['status']).to be_a(String)
        expect(response_json["records"].first).to have_key('category')
        expect(response_json["records"].first['category']).to be_a(String)
        expect(response_json["records"].first).to have_key('channel')
        expect(response_json["records"].first['channel']).to be_a(String)
        expect(response_json["records"].first).to have_key('notification_type')        
        expect(response_json["records"].first).to have_key('media')        
        expect(response_json["records"].first).to have_key('payload')        
        expect(response_json["records"].first).to have_key('users_id')
        expect(response_json["records"].first['users_id']).to be_a(Integer)
        expect(response_json["records"].first).to have_key('cloud_bell_accounts_id')
        expect(response_json["records"].first['cloud_bell_accounts_id']).to be_a(Integer)
    end
end
