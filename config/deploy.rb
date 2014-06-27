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
after "deploy", "symlinks:tmp"
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, roles: :app do
    run "touch #{deploy_to}/shared/tmp/restart.txt"
  end
end

namespace :symlinks do
  task :tmp do
    run "rm -rf #{current_path}/tmp && ln -s #{deploy_to}/shared/tmp #{current_path}/tmp"
  end
end
