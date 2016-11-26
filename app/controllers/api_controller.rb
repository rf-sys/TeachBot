class ApiController < ApplicationController
  require 'net/http'

  before_action :require_guest, only: [:facebook_oauth]

  def bot
    bot = TeachBot::Commands.new(request)
    render :json => bot.generate_response, status: bot.status
  end

  def facebook_oauth
    uri = URI('https://graph.facebook.com/v2.8/oauth/access_token')
    params = {
        :client_id => '371444199855931',
        :redirect_uri => 'http://localhost:3000/oauth/facebook',
        :client_secret => '424883b75def0718d11eb68fc83f9b8d',
        :code => request[:code]
    }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)

    body = JSON.parse(res.body)

    final = URI("https://graph.facebook.com/v2.8/me?access_token=#{body['access_token']}&fields=name,email,picture")
    res = Net::HTTP.get_response(final)

    body = JSON.parse(res.body)

    user = User.where(facebook_id: body['id']).first_or_create(
        username: body['name'],
        email: body['email'],
        avatar: "http://graph.facebook.com/#{body['id']}/picture?height=200&width=200",
        activated: true,
        facebook_id: body['id']
    )

    log_in user
    redirect_to root_path
  end
end
