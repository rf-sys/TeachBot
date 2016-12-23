class ChatController < ApplicationController
  before_action :require_user, :set_user_identifier

  def index
    @chat = get_from_cache(Chat, 1)
    @messages = @chat.messages.includes(:user).order(created_at: :desc).page(params[:page]).per(8)

  end

  private

  def set_user_identifier
    cookies.signed[:chat_user_id] = @current_user.id
  end
end
