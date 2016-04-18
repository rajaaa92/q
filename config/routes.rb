Rails.application.routes.draw do
  resources :jobs, only: :new do
    post :order, on: :collection
  end
  root 'jobs#new'
end
