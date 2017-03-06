Rails.application.routes.draw do

  resources :html2haml, only: [:index, :create], path: 'html2haml'
  resources :html2slim, only: [:index, :create], path: 'html2slim'
  resources :haml2slim, only: [:index, :create], path: 'haml2slim'
  resources :js2coffee, only: [:index, :create], path: 'js2coffee'
  resources :js2yopta,  only: [:index, :create], path: 'js2yopta'
  resources :sql2ar,    only: [:index, :create], path: 'sql2active-record'

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
