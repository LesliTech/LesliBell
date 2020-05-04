CloudBell::Engine.routes.draw do
    root to: 'dashboards#default'
    resources :notifications do
        member do
            put "read"
        end
        collection do
            put "read" => "notifications#read_all"
            get "options"
        end
    end
end
