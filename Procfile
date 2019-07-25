web: bundle exec passenger start
worker: bundle exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e production