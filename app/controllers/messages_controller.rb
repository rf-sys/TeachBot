class MessagesController < ApplicationController
  before_action :require_user
  def create

    message = current_user.messages.new(message_params)

    if message.save
      response = render partial: 'chat/message', locals: {message: message}
      ActionCable.server.broadcast 'ChatChannel', message: response, type: 'message'
    else
      render json: {error: message.errors.full_messages}, status: 422
    end

  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
