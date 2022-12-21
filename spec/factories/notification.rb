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

FactoryBot.define do
    factory :cloud_bell_notification, class: "CloudBell::Notification" do
        subject { Faker::Books::Lovecraft.tome }
        body { Faker::Books::Lovecraft.paragraph }
        url { Faker::Internet.url }
        status { ["read", "sent", "created"].sample }
        category { ["info", "danger", "warning", "success"].sample }
        channel { ["email", "webpush", "mobilepush", "mobiledialog", "push"].sample }

        account { CloudBell::Account.first }
        user { ::User.first }
    end
end