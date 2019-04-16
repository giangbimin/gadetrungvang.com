require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gadetrungvang
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('marketing_campaigns')
    config.autoload_paths << Rails.root.join('workers')
    # Action mailer settings.
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV['SENDGRID_SMTP_ADDRESS'],
      port: ENV['SENDGRID_SMTP_PORT'].to_i,
      enable_starttls_auto: ENV['SENDGRID_SMTP_ENABLE_STARTTLS_AUTO'] == 'true',
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_API_KEY'],
      authentication: ENV['SENDGRID_SMTP_AUTH'],
      domain: ENV['SENDGRID_SMTP_DOMAIN']
    }

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true

    # Set Redis as the back-end for the cache.
    config.cache_store = :redis_store, ENV['REDIS_CACHE_URL']

    # Set Sidekiq as the back-end for Active Job.
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix =
      "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{Rails.env}"
    # Action Cable setting to de-couple it from the main Rails process.
    config.action_cable.url = ENV['ACTION_CABLE_FRONTEND_URL']
  end
end
