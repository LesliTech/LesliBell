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


[{
    subject: Faker::Lorem.sentence(word_count: 3)
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2)
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud')
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    user_receiver_id: (User.all.sample).id
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    user_receiver_emails: [(User.all.sample).email]
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    role_receiver_names: [(Role.all.sample).name],
    media: Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg"),
    payload: {},
    notification_type: ["message", "project-alert", "event-reminder", "overdue-task"].sample,
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    media: Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg"),
    payload: {},
    notification_type: ["message", "project-alert", "event-reminder", "due-task"].sample,
}].each do |notification|

    RSpec.describe 'GET:/bell/notifications', type: :request do

        include_context 'request user authentication'

        it "is expected to respond with notification with #{notification.size} parameters" do

            # register a notification to the user, so we have at least one active notification
            notification_id = (Courier::Bell::Notification.new(
                @current_user, 
                notification['subject'], 
                role_receiver_names: notification['role_receiver_names'], 
                category: notification['category'],
                body: notification['body'], 
                url: notification['url']
            ))[:id][0]

            notification_result = CloudBell::Notification.find(notification_id)

            # get notification
            get("/bell/notifications/#{ notification_id }.json")

            expect_json_response_successful

            response_body = response_json

            expect(response_body['data']['id']).to eql(notification_result.id)
            expect(response_body['data']['subject']).to eql(notification_result[:subject])
            expect(response_body['data']['body']).to eql(notification_result[:body])
            expect(response_body['data']['url']).to eql(notification_result[:url])
            expect(response_body['data']['category'] || 'info').to eql(notification_result[:category])

        end

    end

end
