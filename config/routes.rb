CloudBell::Engine.routes.draw do
    root to: 'dashboards#default'
    resources :emails
    resources :messages
    resources :notifications
    resources :notification_types
    resources :accounts
end
