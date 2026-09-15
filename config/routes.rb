Rails.application.routes.draw do

  root 'main#index'


  match 'about', to: "main#about", via: :get
  match 'hello', to: "main#hello", via: :get

  resources :categories do
    member do
      get :delete
    end
  end

  resources :tasks do
    member do
      get :delete
    end
  end
  
  # get 'main/index'
  # get 'tasks/index'
  # get 'tasks/new'
  # get 'tasks/edit'

  # get 'categories/index'
  # get 'categories/show'
  # get 'categories/new'
  # get 'categories/edit'
  # get 'categories/delete'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
