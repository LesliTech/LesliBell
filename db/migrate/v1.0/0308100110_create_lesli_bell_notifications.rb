=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class CreateLesliBellNotifications < ActiveRecord::Migration[7.0]

    def change
        create_table :lesli_bell_notifications do |t|
            t.string    :subject
            t.text      :body
            t.string    :url
            t.string    :status
            t.string    :category
            t.string    :channel
            t.string    :notification_type
            t.string    :media
            t.json      :payload

            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference(:lesli_bell_notifications, :user, foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_bell_notifications, :account, foreign_key: { to_table: :lesli_accounts })
    end
end
