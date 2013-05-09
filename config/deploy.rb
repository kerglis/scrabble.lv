require "rvm/capistrano"
require "bundler/capistrano"

set :application, "scrabble"
set :repository, "git@bitbucket.org:kristaps_erglis/scrabble.lv.git"
set :scm, :git
set :deploy_via, :remote_cache

set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"

set :stages, %w{demo production}
set :default_stage, "demo"

require "capistrano/ext/multistage"

set :keep_releases, 5
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end