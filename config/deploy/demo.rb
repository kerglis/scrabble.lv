server "xcodus.com", :web, :app, :db, :primary => true
set :user, "rails"
set :use_sudo, false
set :branch, "develop"
set :deploy_to, "~/demo/scrabble.lv"
set :rails_env, "demo"