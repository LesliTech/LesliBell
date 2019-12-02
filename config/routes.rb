CloudBell::Engine.routes.draw do
    root to: 'dashboards#default'
        resources :notifications
      resources :accounts
  
  scope :api do
    scope :notifications do
      put '/:id/read', to: 'notifications#api_read'
    end
  end
  
end
