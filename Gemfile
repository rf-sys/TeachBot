source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
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

gem 'sidekiq'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'capybara'
  gem 'rails-controller-testing'
 # gem 'capybara-webkit'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'meta_request'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
  gem 'rack_session_access'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'

  gem 'rubocop', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# custom gems

# react support
gem 'react-rails'

# handle .es6 files as es6 files and convert to es5
gem 'sprockets-es6'

# ENV support
gem 'figaro'

gem 'bootstrap', '~> 4.0.0.alpha6'

source 'https://rails-assets.org' do
  # tether need for bootstrap
  gem 'rails-assets-tether', '>= 1.1.0'
  gem 'rails-assets-moment'
  gem 'rails-assets-lodash'
  gem 'rails-assets-wysihtml'
  gem 'rails-assets-autosize'
  gem 'rails-assets-cropperjs'
end

# font-awesome
gem 'font-awesome-sass'

# google captcha
gem 'recaptcha'

# mailer service (production)
gem 'sendgrid-ruby'

# pagination gem
gem 'kaminari'

# roles access support
gem 'rolify'

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

gem 'aws-sdk', '~> 2'
# specify active ruby version
ruby '2.3.3'