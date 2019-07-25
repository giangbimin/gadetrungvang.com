set :application, "gadetrungvang.com"
set :repo_url, "git@github.com:giangbimin/gadetrungvang.com.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 3

namespace :sidekiq do

  task :start do
    on roles(:app) do
      within current_path do
        execute :bundle, "exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e production"
      end
    end
  end

  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

  before 'deploy:finished', 'sidekiq:start'

  task :stop do
    on roles(:app) do
      within current_path do
        pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
        execute("kill -9 #{pid}")
      end
    end
  end
end


# Optionally, you can symlink your database.yml and/or secrets.yml file from the shared directory during deploy
# This is useful if you don't want to use ENV variables
# append :linked_files, 'config/database.yml', 'config/secrets.yml'