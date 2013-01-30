Timereporter::Application.routes.draw do
  root to: 'time_entries#index'
  devise_for :users
  resources :time_entries, only: [:index, :create, :update, :destroy]
  resources :podio_sessions, only: [:index, :new]
  resources :projects, only: :index
end
