class PublicChatControllers::MessagesController < ApplicationController
  before_action :set_public_chat
  before_action :require_user, only: [:create]

  def index
    @messages = @public_chat.messages.includes(:user).order(created_at: :desc).page(params[:page] || 1).per(4)
  end

  def create
    message = current_user.messages.new_message(message_params, chat_id: @public_chat.id)

    if message.save
      PublicChatChannel.send_message(message)
      head :no_content
    else
      error_message(message.errors.full_messages, 422)
    end
  end

  private

  def set_public_chat
    @public_chat = get_from_cache(PublicChat, 'public_chat') { PublicChat.take }
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
