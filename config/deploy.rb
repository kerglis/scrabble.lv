require "rvm/capistrano"
require "bundler/capistrano"

set :stages, %w{demo production}
set :default_stage, "demo"
require "capistrano/ext/multistage"

set :scm, :git
set :repository, "git@bitbucket.org:kristaps_erglis/scrabble.lv.git"
# https://kristaps_erglis@bitbucket.org/kristaps_erglis/scrabble.lv.git

set :deploy_via, :remote_cache

set :application, "scrabble"

set :keep_releases, 5
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end