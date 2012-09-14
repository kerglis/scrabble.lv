$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano/ext/multistage"

set :stages, %w{demo production}
set :default_stage, "demo"
set :scm, :git
#set :repository, "git@sz.lv:scrabble-lv.git"
set :repository, "ssh://git@bitbucket.org/kristaps_erglis/scrabble.lv.git"

set :deploy_via, :remote_cache

set :application, "scrabble"
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_ruby_string, "ree-1.8.7-2011.03@#{application}"

set :keep_releases, 5
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end