Timereporter::Application.routes.draw do
  root to: 'time_entries#index'

  devise_for :users
  resources :reports, only: :index do
    collection do
      get "users"
      get "projects"
      get "detail"
      get ":action/:id"
    end
  end
  resources :time_entries do
    collection do
      get "legacy"
    end
  end
  resources :podio_sessions, only: [:index, :new]
  resources :projects, only: [:index, :show]
end
