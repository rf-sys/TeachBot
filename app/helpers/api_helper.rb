module ApiHelper
  require 'net/http'

  module Facebook
    def code_exist?(code)
      unless code
        return false
      end
      true
    end

    def valid_access_token(access_token)
      unless access_token
        return false
      end

      uri = URI("https://graph.facebook.com/debug_token")
      params = {
          :input_token => access_token,
          :access_token => access_token,
      }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)

      validation_response = JSON.parse(response.body)

      unless validation_response['data']['is_valid']
        return false
      end

      true
    end

    def get_access_token(code)
      uri = URI('https://graph.facebook.com/v2.8/oauth/access_token')
      params = {
          :client_id => '371444199855931',
          :redirect_uri => "#{Rails.application.config.development_host}oauth/facebook",
          :client_secret => ENV['FACEBOOK_APP_SECRET'],
          :code => code
      }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)

      JSON.parse(response.body)
    end

    def get_user_data(access_token)
      request = URI("https://graph.facebook.com/v2.8/me?access_token=#{access_token}&fields=name,email,picture")

      response = Net::HTTP.get_response(request)

      JSON.parse(response.body)
    end


    def create_or_initialize_user(user)
      User.where(facebook_id: user['id']).first_or_create(
          username: user['name'],
          email: user['email'],
          avatar: "https://graph.facebook.com/#{user['id']}/picture?height=200&width=200",
          activated: true,
          facebook_id: user['id']
      )
    end
  end
end
