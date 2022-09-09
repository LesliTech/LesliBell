=begin

Copyright (c) 2020, all rights reserved.

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

CloudBell::Engine.routes.draw do
    # namespace :notification do
    #     resources :activities
    # end

    # namespace :announcement do
    #     resources :activities
    # end

    resources :announcement_users

    root to: "dashboards#show"

    resources :notifications, only: [:index, :new, :show, :create, :edit, :update] do
        member do
            scope :resources do
                put :read
            end
        end

        collection do
            put :read
            get :options
            get :count
            get :list
        end

        scope module: :notification do
            resources :activities
        end

    end

    resources :announcements, only: [:index, :new, :show, :create, :edit, :update, :destroy] do 
        collection do
            get :options
            get :list
        end

        scope module: :announcement do
            resources :activities
        end

    end
end
