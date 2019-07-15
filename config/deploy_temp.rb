require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :application, 'deploy'
set :repository, 'git@github.com:giangbimin/gadetrungvang.com.git'
set :user, 'deploy'
set :deploy_to, "/home/deploy/#{fetch :application}"
set :branch, 'master'
set :rails_env, 'production'
set :domain, '52.221.203.224'
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

task :remote_environment do
  invoke :'rbenv:load'
end

task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
  command %{mkdir -p "fetch(:deploy_to)/shared/log"}
  command %{chmod g+rx,u+rwx "fetch(:deploy_to)/shared/log"}

  command %{mkdir -p "fetch(:deploy_to)/shared/config"}
  command %{chmod g+rx,u+rwx "fetch(:deploy_to)/shared/config"}

  command %{mkdir -p "fetch(:deploy_to)/shared/tmp"}
  command %{chmod g+rx,u+rwx "fetch(:deploy_to)/shared/tmp"}

  command %{touch "fetch(:deploy_to)/shared/config/database.yml"}
  command %{touch "fetch(:deploy_to)/shared/config/application.yml"}
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      queue %{
          echo "Export ENV KEY"
      }
      # queue %{
      #   #{echo_cmd %{cd "fetch(:deploy_to)/#{current_path}"}}
      #   echo "Running export i18n:js"
      #   #{echo_cmd %{RAILS_ENV=production bundle exec rake i18n:js:export]}
      # }
      invoke :'passenger:restart'
    end
  end
end
namespace :passenger do
  task :restart do
    in_path(fetch(:current_path)) do
      comment 'Restarting passenger'
      command %(touch tmp/restart.txt)
    end
  end
end
