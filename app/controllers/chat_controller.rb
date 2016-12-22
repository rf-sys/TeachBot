class ChatController < ApplicationController
  before_action :require_user, :set_user_identifier

  def index
    @messages = Message.includes(:user).order(created_at: :desc).page(params[:page]).per(8)
    @message = Message.new
  end

  private

  def set_user_identifier
    cookies.signed[:chat_user_id] = @current_user.id
  end
end
