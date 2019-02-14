Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  root 'static_pages#home'
  post '/signup', to: 'users#create'
  #  リソースを追加して標準的なRESTfulアクションをgetできるようにする
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destory'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  # Micropostsリソースへのインターフェイスは、主にプロフィールページとHOMEページのコントローラを経由するので
  # Micropostsコントローラーにはnewやeditアクションは不要
  resources :microposts, only: [:create, :destroy]
end
