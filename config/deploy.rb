require "rvm/capistrano"
require "bundler/capistrano"

set :stages, %w{demo production}
set :default_stage, "demo"
require "capistrano/ext/multistage"

set :scm, :git
set :repository, "https://github.com/kerglis/scrabble.lv.git"

set :deploy_via, :remote_cache

set :application, "scrabble"
# set :rvm_bin_path, "/usr/local/rvm/bin"
# set :rvm_ruby_string, "ree-1.8.7-2011.03@#{application}"

set :keep_releases, 5
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end