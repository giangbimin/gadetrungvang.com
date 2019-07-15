require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :application, 'deploy'
set :repository, 'git@github.com:giangbimin/gadetrungvang.com.git'
set :user, 'deploy'
set :deploy_to, "/home/deploy/#{fetch :application}"
set :branch, 'master'
set :rails_env, 'production' # Môi trường
set :domain, 'gadetrungvang.com'
# set :forward_agent, true
# set :port, '22'
set :application_name, 'gadetrungvang'
set :term_mode, nil

set :shared_paths, [
  'config/database.yml',
  'config/application.yml',
  'tmp',
  'log'
]

task :environment do
  invoke :'rbenv:load'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
end

desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue %{
          echo "Export ENV KEY"
      }
      # queue %{
      #   #{echo_cmd %[cd "#{deploy_to}/#{current_path}"]}
      #   echo "Running export i18n:js"
      #   #{echo_cmd %[RAILS_ENV=production bundle exec rake i18n:js:export]}
      # }
      invoke :'passenger:restart'
    end
  end
end

namespace :passenger do
  desc "Restart Passenger"
  task :restart do
    queue %{
      echo "-----> Restarting passenger"
      cd #{deploy_to}/current
      #{echo_cmd %[mkdir -p tmp]}
      #{echo_cmd %[touch tmp/restart.txt]}
    }
  end
end