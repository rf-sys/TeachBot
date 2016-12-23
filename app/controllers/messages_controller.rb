class MessagesController < ApplicationController
  before_action :require_user

  def create

    chat = get_from_cache(Chat, params[:chat_id])
    message = current_user.messages.new(message_params)

    if chat.messages << message
      ac_message_broadcast(message)
    else
      error_message(message.errors.full_messages, 422)
    end

  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

  def ac_message_broadcast(message)
    response = render partial: 'chat/message', locals: {message: message}
    ActionCable.server.broadcast 'ChatChannel', message: response, type: 'message'
  end
end
