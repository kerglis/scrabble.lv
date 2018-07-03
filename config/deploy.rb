lock '3.11.0'

set :application, 'scrabble'
set :repo_url, 'git@github.com:kerglis/scrabble.lv.git'
set :log_level, :info
set :linked_files, %w{ tmp/restart.txt }
set :linked_dirs, %w{ bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads }

set :rvm_ruby_version, '2.3.7@scrabble'
set :passenger_restart_with_touch, true
