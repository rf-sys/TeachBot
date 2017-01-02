class ChatControllers::MessagesController < ApplicationController
  before_action :require_user

  def create

    chat = get_from_cache(Chat, params[:chat_id])

    unless chat.id == 1
      unless current_user_related_to_chat(chat)
        error_message('Forbidden', 403)
      end
    end

    message = current_user.messages.new(message_params)

    if chat.messages << message
      render :json => {:message => 'Message has been sent'}
      ac_message_broadcast(message)
      ac_notification_send(chat.users, send_json(message))
    else
      error_message(message.errors.full_messages, 422)
    end

  end


  private

  def message_params
    params.require(:message).permit(:text)
  end

  def ac_message_broadcast(message)
    ActionCable.server.broadcast "Chat:#{message.chat_id}", response: send_json(message), type: 'message'
  end

  def ac_notification_send(users, data)
    users = users - [current_user]
    puts users.to_s

    users.each { |user| NotificationsChannel.broadcast_to(user, response: data, type: 'message') }

  end

  def send_json(msg)
    {
        message: {
            id: msg.id,
            text: msg.text,
            chat_id: msg.chat_id,
            user: msg.user.attributes.slice('id', 'username', 'avatar')
        }
    }
  end

  def current_user_related_to_chat(chat)
    chat.users.include?(current_user)
  end
end
