require_relative 'boot'

require 'rails/all'
require 'recaptcha/rails'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Firstapp
  class Application < Rails::Application

    config.autoload_paths << "#{Rails.root}/lib"
    config.cache_store = :file_store, "#{Rails.root}/tmp/cache/file_store"
    config.react.addons = true
    config.browserify_rails.commandline_options = '-t [ babelify --presets [ es2015 react ] --extensions .jsx ]'
    config.active_job.queue_adapter = :resque

    config.api_keys = {
        :google_api_key => 'AIzaSyAl3hIWaCvf2w4jFNa5lyRcfHggb7dcFvQ',
        :facebook_api_key => '371444199855931'
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
