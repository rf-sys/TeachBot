# base class for api inheritance
class ApiController < ApplicationController
  require_dependency 'services/json_web_token.rb'
  before_action :default_format
  skip_before_action :verify_authenticity_token

  def default_format
    request.format = :json
  end

  # POST - get JWT token
  def user_token
    user = User.find_by(email: params[:email], uid: nil)

    return head :not_found unless user

    return head :forbidden unless user.authenticate(params[:password])

    render json: { token: JsonWebToken.encode(payload(user)) }
  end

  # authenticate jwt token
  def authenticate_jwt
    return true if logged_in?

    return error_message(['Unauthorized'], 401) unless sub_present?

    user = User.find(decoded_jwt_token['sub'])

    return error_message(['Unauthorized'], 401) unless user
  rescue StandardError
    return error_message(['Unauthorized'], 401)
  end

  private

  def payload(user)
    {
      iss: Rails.application.config.development_host,
      sub: user.id,
      aud: 'users',
      exp: Time.now.to_i + 1.day
    }
  end

  def jwt_token
    return if request.headers['Authorization'].blank?
    request.headers['Authorization'].split(' ').last
  end

  def decoded_jwt_token
    JsonWebToken.decode(jwt_token)
  end

  def sub_present?
    jwt_token && decoded_jwt_token && decoded_jwt_token['sub'].to_i
  end
end
