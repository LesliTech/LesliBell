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


file = File.open(LesliBell::Engine.root.join("db", "seed", "seeds.json")).read
seeds = JSON.parse(file)

current_user = Lesli::User.first

# · 
seeds["announcements"].each do |notification|
    LesliBell::AnnouncementService.new(current_user).create({
        name: notification["name"],
        category: notification["category"],
        message: notification["message"],
        url: notification["url"]
    }, send_to_user_ids: ::Lesli::User.all.pluck(:id))
end 
