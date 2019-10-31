CloudBell::Engine.routes.draw do
  resources :notification_deliverers
    root to: 'dashboards#default'
    resources :emails
    resources :messages
    resources :notifications
      resources :accounts
end
