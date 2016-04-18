Rails.application.routes.draw do
  resources :jobs, only: :new
  root 'jobs#new'
end
