CloudBell::Engine.routes.draw do
    root to: 'dashboards#default'
    resources :notifications
end
