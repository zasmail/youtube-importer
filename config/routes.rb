Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'facebook_graph_callback', to: 'fb_callback#new'
  get 'callback', to: 'fb_callback#new'

  mount_ember_app :frontend, to: "/"

  resources :fb_authentication, only: [:index, :create]
  resources :get_data, only: [:index, :create]

end
