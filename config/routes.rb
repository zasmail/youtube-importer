Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'facebook_graph_callback', to: 'fb_callback#new'
  get 'callback', to: 'fb_callback#new'

  resources :fb_authentication, only: [:index, :create]

end
