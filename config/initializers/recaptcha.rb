Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_PUBLIC_KEY'] || 'random_stings' # smth. alternative needs to pass capybara tests
  config.secret_key = ENV['RECAPTCHA_PRIVATE_KEY']
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
