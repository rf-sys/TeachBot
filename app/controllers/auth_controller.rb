# Oauth
class AuthController < ApplicationController
  before_action :require_guest

  def facebook
    redirect_to 'https://www.facebook.com/v2.8/dialog/oauth?' \
                "client_id=#{ENV['FACEBOOK_APP_ID']}&" \
                "redirect_uri=#{auth_facebook_callback_url}"
  end

  def github
    redirect_to 'https://github.com/login/oauth/authorize?' \
                "client_id=#{ENV['GITHUB_APP_ID']}" \
                "redirect_uri=#{auth_github_callback_url}" \
                "state=#{SecureRandom.hex}"
  end

  # common callback for all provided oauth services
  def auth_callback
    user = User.find_or_create_from_auth_hash(auth_hash)
    log_in_and_redirect_with_back(user)
  rescue StandardError => e
    flash[:danger_notice] = e.message
    redirect_to root_url
  end

  # check omniauth errors
  # Error is raised in config/initializers/omniauth.rb
  def omniauth_failure
    flash[:danger_notice] = 'Authentication failed'
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
