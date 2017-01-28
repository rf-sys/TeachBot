class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base

  def self.encode(payload)
    JWT.encode payload, SECRET_KEY, 'HS256'
  end

  def self.decode(token)
    decoded_token = JWT.decode token, SECRET_KEY, true, {:algorithm => 'HS256'}
    decoded_token.first
  rescue
    nil
  end
end