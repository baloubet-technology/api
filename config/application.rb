require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.exceptions_app = self.routes
    config.load_defaults 6.0
    config.assets.initialize_on_precompile = false
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_token => ENV['POSTMARK_API_TOKEN'] }
    config.active_job.queue_adapter = :sidekiq
    Redis.exists_returns_integer = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
      end
    end
  end
end
