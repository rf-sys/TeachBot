class MessagesController < ApplicationController
  before_action :require_user

  def create
    user = User.find(params[:user_id])

    unless user
      error_message(['Recipient not found'], 404)
    end

    @chat = Chat.find_or_initialize_between(current_user, user)

    @message = init_message

    if @chat.new_record?
      @chat.save_with_participants
      save_message(@chat, @message)
    else
      save_message(@chat, @message) do
        render json: {response: @message, type: :new_message}
      end
    end

  end

  private

  def message_params
    params.require(:message).permit(:text)
  end


  def ac_message_broadcast(message)
    ActionCable.server.broadcast "Chat:#{message.chat_id}", response: send_json(message), type: 'message', head: :ok
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

  def init_message
    message = Message.new(message_params)
    message.user = current_user
    message
  end

  def save_message(chat, message)
    if chat.messages << message
      ac_message_broadcast(message)
      if block_given?
        yield
      end
    else
      error_message(message.errors.full_messages, 422)
    end
  end
end
