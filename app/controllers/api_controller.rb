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

    unless user
      return head :not_found
    end

    unless user.authenticate(params[:password])
      return head :forbidden
    end

    render json: {token: JsonWebToken.encode(payload(user))}
  end

  # authenticate jwt token
  def authenticate_jwt
    return true if current_user

    unless sub_present?
      return error_message(['Unauthorized'], 401)
    end

    user = User.find(decoded_jwt_token['sub'])

    unless user
      return error_message(['Unauthorized'], 401)
    end

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
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    else
      nil
    end
  end

  def decoded_jwt_token
    JsonWebToken.decode(jwt_token)
  end

  def sub_present?
    jwt_token && decoded_jwt_token && decoded_jwt_token['sub'].to_i
  end
end
