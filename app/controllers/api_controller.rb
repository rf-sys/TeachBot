class ApiController < ApplicationController
  require 'net/http'
  include ApiHelper::Facebook

  before_action :require_guest, only: [:facebook_oauth]

  def bot
    bot = TeachBot::Commands.new(request)
    render :json => bot.generate_response, status: bot.status
  end

  def facebook_oauth

    return fb_validation_error unless code_exist?(request[:code])

    access_token = get_access_token request[:code]

    return fb_validation_error unless valid_access_token?(access_token['access_token'])

    fb_user = get_user_data(access_token['access_token'])

    begin
      user = create_or_initialize_user(fb_user)
    rescue StandardError => e
      return fb_validation_error(e.message)
    end

    log_in user

    redirect_to root_path
  end



  def subscriptions_pagination
    if current_user
      # @subscriptions ||= current_user.subscriptions.paginate(:page => params[:page], :per_page => 2)
      @subscriptions ||= current_user.subscriptions.page(params[:page]).per(2)

      render :partial => 'courses/pagination'

    end
  end


  private

  def fb_validation_error(error = 'Something went wrong. Try login with facebook again')
    redirect_to root_path, flash: {danger_notice: error}
  end
end
