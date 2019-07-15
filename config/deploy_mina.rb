require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

# Basic settings:
set :application, 'deploy'
set :domain, '52.221.203.224'
set :deploy_to, '/home/deploy/#{fetch :application'
set :repository, 'https://github.com/giangbimin/gadetrungvang.com.git'
set :user, 'deploy'
set :branch, 'master'
# set :term_mode, nil
# set :execution_mode, :system
# set :forward_agent, true     # SSH forward_agent.

set :shared_paths, [
  'config/database.yml',
  'config/application.yml',
  'config/secrets.yml',
  'tmp',
  'log'
]
task :remote_environment do
  invoke :'rbenv:load'
end

task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
  command %[mkdir -p "#{fetch(:shared_paths)}/shared/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_paths)}/shared/log"]

  command %[mkdir -p "#{fetch(:shared_paths)}/shared/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_paths)}/shared/config"]

  command %[mkdir -p "#{fetch(:shared_paths)}/shared/tmp"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_paths)}/shared/tmp"]

  command %[touch "#{fetch(:shared_paths)}/shared/config/database.yml"]
  command %[touch "#{fetch(:shared_paths)}/shared/config/application.yml"]
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
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end
end
