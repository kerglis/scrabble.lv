ScrabbleLv::Application.routes.draw do
  get '/users/auth/:provider' => 'oauth_callbacks#passthru'

  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    sessions: 'sessions'
  }

  scope '/:locale', locale: /lv|en/ do
    resource :user, only: [:show, :update]

    resource :dictionary, only: [:show] do
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
