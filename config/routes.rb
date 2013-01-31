Timereporter::Application.routes.draw do
  root to: 'time_entries#index'
  devise_for :users
  resources :time_entries, only: [:index, :create, :update, :destroy] do
  	collection do
  		get :user_report
  		get :project_report
  	end
  end
  resources :podio_sessions, only: [:index, :new]
  resources :projects, only: :index
end
