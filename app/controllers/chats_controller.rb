class ChatsController < ApplicationController
  before_action :require_user
  after_action :delete_if_no_participants, only: [:leave]

  def public_chat
    @chat = get_from_cache(Chat, 'public_chat') { Chat.public_chat }
  end

  def index
  end

  # DELETE - leave from chat
  def leave
    @chat = Chat.find(params[:id])
    @chat.users.delete(current_user)
    render json: {status: 'done'}, status: :ok
    ChatChannel.send_notification_to_chat(@chat.id, "#{current_user.username} left the chat")
  end

  private

  def delete_if_no_participants
    @chat.destroy if @chat.users.count <= 1
  end

end
