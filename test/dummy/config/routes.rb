Rails.application.routes.draw do
  mount CloudBell::Engine => "/cloud_bell"
end
