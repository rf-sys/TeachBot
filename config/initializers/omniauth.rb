Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
           image_size: :large, secure_image_url: true
  provider :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET']
end

OmniAuth.config.on_failure = AuthController.action(:omniauth_failure)