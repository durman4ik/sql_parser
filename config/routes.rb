Rails.application.routes.draw do


  get 'html-converter' => 'html#index', as: :html
  get 'js-converter'   => 'js#index',   as: :js
  get 'sql-converter'  => 'sql#index',  as: :sql

  post 'sql-converter'  => 'sql#convert',  as: :convert_sql

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
