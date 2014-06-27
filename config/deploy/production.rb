server "d-ltal", :web, :app, :db, primary: true
set :user, "rails"
set :use_sudo, false
set :branch, "develop"
set :deploy_to, "/home/rails/production/scrabble.lv"
set :rails_env, "production"