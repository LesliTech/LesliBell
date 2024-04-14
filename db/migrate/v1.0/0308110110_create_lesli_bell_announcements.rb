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

class CreateLesliBellAnnouncements < ActiveRecord::Migration[6.0]
    def change
        create_table :lesli_bell_announcements do |t|
            t.string    :name
            t.string    :url, index: true
            t.string    :category
            t.string    :base_path
            t.text      :message
            t.boolean   :status
            t.datetime  :start_at
            t.datetime  :end_at
            t.boolean   :can_be_closed, :default => true

            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference(:lesli_bell_announcements, :user, foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_bell_announcements, :role, foreign_key: { to_table: :lesli_roles })
        add_reference(:lesli_bell_announcements, :account, foreign_key: { to_table: :lesli_accounts })
    end
end
