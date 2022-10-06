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


require 'rails_helper'
require 'spec_helper'
require 'byebug'


RSpec.describe 'lib/cloud_bell/version.rb', type: :request do

    it 'is expected to have valid VERSION information' do
        version = CloudBell::VERSION
        expect(version.class.to_s).to eql('String')
        expect(version.length).to be >= 5
    end

    it 'is expected to have valid BUILD information' do 
        build = CloudBell::BUILD
        expect(build.class.to_s).to eql('String')
    end 

end
