source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# worker
gem 'sidekiq'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.5'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'poltergeist'
  gem 'rack_session_access'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # add test coverage support
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# custom gems

# react support
gem 'react-rails'

# ENV support
gem 'dotenv-rails', groups: %i[development test]

gem 'bootstrap', '~> 4.0.0.alpha6'

source 'https://rails-assets.org' do
  # tether need for bootstrap
  gem 'rails-assets-autosize'
  gem 'rails-assets-cropperjs'
  gem 'rails-assets-lodash'
  gem 'rails-assets-moment'
  gem 'rails-assets-tether', '>= 1.1.0'
  gem 'rails-assets-wysihtml'
end

# font-awesome
gem 'font-awesome-sass'

# selectize.js
gem 'selectize-rails'

# google captcha
gem 'recaptcha'

# pagination gem
gem 'kaminari'

# animate.css support
gem 'animate_css_on_rails'

# facebook oauth
gem 'omniauth-facebook'

# github oauth
gem 'omniauth-github'

# jwt support
gem 'jwt'

# replace 'id' in url with recognized string
gem 'friendly_id'

# to insert a bunch of new records with one query
gem 'activerecord-import', '~> 0.17.1'

# validate image files
gem 'fastimage'

# AWS support
gem 'aws-sdk', '~> 2'

# connect rails and ElasticSearch
gem 'faraday_middleware-aws-signers-v4'

# elasticsearch support
gem 'searchkick'

# webpack integration (Rails 5.1)
gem 'webpacker'

# specify current ruby version
ruby '2.4.1'