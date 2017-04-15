require_relative 'boot'

require 'rails/all'
require 'recaptcha/rails'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Teachbot
  class Application < Rails::Application

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib') # it uses instead of autoload_paths in production
    config.cache_store = :file_store, Rails.root.join('tmp', 'cache', 'file_store')
    config.react.addons = true
    config.active_job.queue_adapter = :sidekiq

    config.api_keys = {
      google_api_key: 'AIzaSyAl3hIWaCvf2w4jFNa5lyRcfHggb7dcFvQ'
    }

    config.action_view.sanitized_allowed_tags = %w(b p i strong u s h1 h2 img a div hr code ul ol li blockquote)
    config.action_view.sanitized_allowed_attributes = %w(src href class)

    config.application_version = '1.1'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
