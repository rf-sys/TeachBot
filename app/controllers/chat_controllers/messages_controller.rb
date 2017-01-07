class ChatControllers::MessagesController < ApplicationController
  include MessagesHelper, MessageStrategy::MessageCreateStrategy
  before_action :require_user

  def create

    chat = get_from_cache(Chat, params[:chat_id])

    message = current_user.messages.new(message_params)

    strategy = MessageCreateStrategyClass.new(chat, message, current_user)

    unless strategy.have_access?
      return error_message('Forbidden', 403)
    end

    if chat.public_chat
      save_message(strategy, PublicChatMessage.new)
    else
      save_message(strategy, PrivateChatMessage.new) { render :json => {:message => 'Message has been sent'} }
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

  def save_message(strategy, message_entity)
    entity = message_entity

    unless strategy.save(entity)
      return error_message(entity.errors, 422)
    end

    if block_given?
      yield
    end
  end

end
