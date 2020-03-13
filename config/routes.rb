Rails.application.routes.draw do
  post "shops/create" => "shops#create"
  get "shops/new" => "shops#new"
  get "shops/index" => "shops#index"
  get "shops/login_form" => "shops#login_form"
  post "shops/login" => "shops#login"
  get "shops/:id" => "shops#show"
  get "shops/:id/edit" => "shops#edit"
  get "shops/:id/password_reset" => "shops#password_reset"
  post "shops/:id/update" => "shops#update"
  post "shops/:id/destroy" => "shops#destroy"
  get "owner" => "home#owner"
  get "about" => "home#about"
  get "/" => "home#top"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
