require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, 'scrabble'
set :repository, 'git@bitbucket.org:kristaps_erglis/scrabble.lv.git'
set :scm, :git
set :deploy_via, :remote_cache
set :rvm_ruby_string, :local

set :stages, %w(demo production)
set :default_stage, 'demo'

require 'capistrano/ext/multistage'

set :keep_releases, 5
after 'deploy:update_code', 'deploy:migrate'
after 'deploy', 'symlinks:tmp'
after 'deploy', 'deploy:cleanup'
