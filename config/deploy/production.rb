server "scrabble.spy.lv", :web, :app, :db, primary: true
set :user, "rails"
set :use_sudo, false
set :branch, "master"
set :deploy_to, "/home/rails/production/scrabble.lv"
set :rails_env, "production"
