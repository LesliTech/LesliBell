LesliBell::Engine.routes.draw do  
    root to: "dashboards#show"
    resource :dashboard, only: [:show]
    resources :notifications, only: [:index]
    resources :announcements, only: [:index]
end
