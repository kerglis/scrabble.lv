role :app, %w{rails@scrabble.spy.lv}
role :web, %w{rails@scrabble.spy.lv}
role :db,  %w{rails@scrabble.spy.lv}

server 'scrabble.spy.lv', user: 'rails', roles: %w{web app}

set :branch, :master
set :deploy_to, '/home/rails/production/scrabble.lv'
