# represents page with user's chats and related logic
# (like add participant or leave from the chat)
class ChatsController < ApplicationController
  include UsersHelper
  include ChatsHelper
  before_action :authenticate_user!
  before_action :set_chat, only: %i[leave add_participant kick_participant]
  after_action :delete_if_no_participants, only: [:leave]

  def index
    respond_to do |format|
      format.any(:js, :json) do
        @chats = current_user.chats.where(public_chat: false).distinct
      end
      format.html {}
    end
  end

  # DELETE - leave from chat
  def leave
    @chat.members.delete(current_user)
    render json: { status: 'done' }, status: :ok
    ChatChannel.send_notification_to_chat(@chat.id, user_left_the_chat_msg)
  end

  # POST - add new user to chat
  def add_participant
    user = User.find(params[:user_id])

    unless user_is_initiator(current_user, @chat)
      return fail_response(['You are not an author of the conversation'], 403)
    end

    if user_related_to_chat(@chat, user)
      return fail_response(['User is already in chat'], 403)
    end

    @chat.add_participant(user)

    render json: { message: 'success' }, status: :ok
  end

  # DELETE - delete user from chat
  def kick_participant
    user = User.find(params[:user_id])

    unless user_is_initiator(current_user, @chat)
      return fail_response(['You are not an author of the conversation'], 403)
    end

    if user == current_user
      return fail_response(['Author cannot kick yourself'], 403)
    end

    @chat.kick_participant(user)

    render json: { message: 'success' }, status: :ok
  end

  private

  def delete_if_no_participants
    @chat.destroy if @chat.members.count <= 1
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def user_left_the_chat_msg
    "#{current_user.username} left the chat"
  end
end
