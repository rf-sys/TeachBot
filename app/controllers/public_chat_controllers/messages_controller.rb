class PublicChatControllers::MessagesController < ApplicationController
  before_action :set_public_chat
  before_action :authenticate_user!, only: [:create]

  def index
    page = params[:page]
    @messages = Message.for_chat(@public_chat).public_format.paginate(page, 5)
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
    @public_chat = fetch_cache(PublicChat, 'public_chat') { PublicChat.take }
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
