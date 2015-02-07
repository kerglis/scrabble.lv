ScrabbleLv::Application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'

  get '/users/auth/:provider' => 'oauth_callbacks#passthru'
  get '/admin' => 'admin/users#index', locale: :lv

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", sessions: 'sessions' }

  scope "/:locale", locale: /lv|en/ do

    namespace :admin do

      resources :users do
        member do
          get :restore
          get :swap
          get :change_password
        end
        collection do
          post :filter
        end
      end

      resources :games

      root to: 'users#index'
    end

    resource :user, only: [ :show, :update ]

    resource :dictionary, only: [ :show ] do
      member do
        post :check_word
        get :check_word
        post :find_words
        get :find_words
      end
    end

    root to: 'welcome#index'
  end

  get '/' => 'welcome#index', locale: :lv

end