class ApiController < ApplicationController
  require 'net/http'
  include ApiHelper::Facebook

  before_action :require_guest, only: [:facebook_oauth]

  def bot
    bot = TeachBot::Commands.new(request)
    render :json => bot.generate_response, status: bot.status
  end

  def facebook_oauth

    unless code_exist?(request[:code])
      return fb_validation_error
    end

    access_token = get_access_token request[:code]

    unless valid_access_token(access_token['access_token'])
      return fb_validation_error
    end

    fb_user = get_user_data(access_token['access_token'])

    log_in create_or_initialize_user(fb_user)

    redirect_to root_path
  end


  private

  def fb_validation_error
    redirect_to root_path, flash: {
        danger_notice: 'Something went wrong. Try login with facebook again'
    }
  end
end
