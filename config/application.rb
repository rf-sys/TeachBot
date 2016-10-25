require_relative 'boot'

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Firstapp
  class Application < Rails::Application

    config.autoload_paths += %W(#{config.root}/lib)
    config.cache_store = :file_store, "cache"
    config.react.addons = true
    config.public_file_server.enabled = true
    config.browserify_rails.commandline_options = '-t [ babelify --presets [ es2015 react ] --extensions .jsx ]'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
