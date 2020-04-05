CloudBell::Engine.routes.draw do
    root to: 'dashboards#default'
    resources :notifications do
        member do
            put "read"
        end
        collection do
            put "read_all"
        end
    end
end
