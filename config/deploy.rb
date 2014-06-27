require "rvm/capistrano"
require "bundler/capistrano"

set :application, "scrabble"
set :repository, "git@bitbucket.org:kristaps_erglis/scrabble.lv.git"
set :scm, :git
set :deploy_via, :remote_cache
set :rvm_ruby_string, :local

set :stages, %w{demo production}
set :default_stage, "demo"

require "capistrano/ext/multistage"

set :keep_releases, 5
after "deploy:update_code", "deploy:migrate"
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, roles: :app do
    run "touch #{deploy_to}/shared/tmp/restart.txt"
  end
end
