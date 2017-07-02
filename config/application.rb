require_relative 'boot'

require 'rails/all'
require 'recaptcha/rails'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Teachbot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.action_cable.mount_path = '/websocket'
    config.action_cable.url = '/websocket'
    config.action_cable.allowed_request_origins = [ %r{\Ahttps?:\/\/#{ENV['APP_HOST']}.*\z} ]

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib') # it uses instead of autoload_paths in production
    config.cache_store = :file_store, Rails.root.join('tmp', 'cache', 'file_store')
    config.react.addons = true
    config.active_job.queue_adapter = :sidekiq

    config.action_view.sanitized_allowed_tags = %w[b p i strong u s h1 h2 img a div hr code ul ol li blockquote]
    config.action_view.sanitized_allowed_attributes = %w[src href class]

    config.application_version = '1.1'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
