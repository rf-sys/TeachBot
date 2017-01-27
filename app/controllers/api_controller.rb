class ApiController < ApplicationController
  require 'net/http'
  include MessagesHelper

  def bot
    bot = TeachBot::Commands.new(request)
    render :json => bot.generate_response, status: bot.status
  end

  # find user by username and return as json
  # @return [Object]
  def find_user_by_username
    if params[:username]
      users = User.select(:id, :username, :avatar).where('username LIKE ?', "%#{params[:username]}%").limit(10)
      render :json => {users: users}
    end
  end
end
