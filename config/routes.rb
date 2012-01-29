ScrabbleLv::Application.routes.draw do

  match '/users/auth/:provider' => 'oauth_callbacks#passthru'

  scope "/:locale", :locale => /lv/ do

    devise_for :users, :controllers => { :omniauth_callbacks => "oauth_callbacks" }

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

      root :to => 'games#index'
    end

    resource :user
    resources :games

    match "/*path" => "contents#index"
    root :to => 'welcome#index'
  end

  match '/' => 'welcome#index', :locale => :lv

end