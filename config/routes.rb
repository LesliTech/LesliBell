CloudBell::Engine.routes.draw do
  resources :notification_deliverers
    root to: 'dashboards#default'
    resources :emails
    resources :messages
    resources :notifications
      resources :accounts
  
  scope :api do
    scope :notifications do
      put '/:id/read', to: 'notifications#api_read'
    end
  end
  
end
