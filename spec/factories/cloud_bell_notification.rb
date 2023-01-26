=begin
Copyright (c) 2023, all rights reserved.

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

FactoryBot.define do
    factory :cloud_bell_notification, class: "CloudBell::Notification" do
        subject { Faker::Lorem.sentence(word_count: 3) }
        body { Faker::Lorem.paragraph(sentence_count: 10) }
        url { Faker::Internet.url(host: 'test.lesli.cloud') }
        category { ["info", "danger", "warning", "success"].sample }

        account { CloudBell::Account.first }
        user { ::User.first }
    end
end