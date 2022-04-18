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
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    role_receiver_names: [(Role.all.sample).name],
    media: Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg"),
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    user_receiver_emails: [(User.all.sample).email],
    notification_type: ["message", "project-alert", "event-reminder", "overdue-task"].sample,
    payload: {}
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    role_receiver_names: [(Role.all.sample).name],
    media: Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg"),
    notification_type: ["message", "project-alert", "event-reminder", "overdue-task"].sample,
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    media: Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg"),
    user_receiver_emails: [(User.all.sample).email],
    payload: {
        chatroom_uid: Faker::Alphanumeric.alphanumeric(number: 15)
    }
}, {
    subject: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 2),
    category: ["info", "danger", "warning", "success"].sample,
    url: Faker::Internet.url(host: 'test.lesli.cloud'),
    media: Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg"),
    role_receiver_names: [(Role.all.sample).name],
    payload: {
        chatroom_uid: Faker::Alphanumeric.alphanumeric(number: 15)
    },
    notification_type: ["message", "project-alert", "event-reminder", "overdue-task"].sample,
}].each do |notification|

    RSpec.describe 'POST:/bell/notifications', type: :request do
        include_context 'request user authentication'

        it "is expected to create a new notification with #{notification.size} parameters" do

            post("/bell/notifications.json", params: {
                notification: notification
            })

            # sharec examples
            expect_json_response_successful

            # custom
            response_body = response_json
            notification_id = response_body['data']['id']
            notification_result = CloudBell::Notification.where(:id => notification_id).first

            expect(notification_id).to include(notification_result.id)
        end
    end
end
