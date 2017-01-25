class ChatsController < ApplicationController
  include ChatsHelper, UsersHelper
  before_action :require_user
  before_action :set_chat, only: [:leave, :add_participant, :kick_participant]
  after_action :delete_if_no_participants, only: [:leave]

  def public_chat
    @chat = get_from_cache(Chat, 'public_chat') { Chat.public_chat }
  end

  def index
  end

  # DELETE - leave from chat
  def leave
    @chat.users.delete(current_user)
    render json: {status: 'done'}, status: :ok
    ChatChannel.send_notification_to_chat(@chat.id, "#{current_user.username} left the chat")
  end

  # POST - add new user to chat
  def add_participant
    user = User.find(params[:user_id])

    unless user_is_initiator(current_user, @chat)
      return deny_access_message('You are not an author of the conversation')
    end

    if user_related_to_chat(@chat, user)
      return deny_access_message('User is already in chat')
    end

    @chat.add_participant(user)

    render json: {message: 'success'}, status: :ok
  end

  # DELETE - delete user from chat
  def kick_participant
    user = User.find(params[:user_id])

    unless user_is_initiator(current_user, @chat)
      return deny_access_message('You are not an author of the conversation')
    end

    if user == current_user
      return deny_access_message('Author cannot kick yourself')
    end

    @chat.kick_participant(user)

    render json: {message: 'success'}, status: :ok
  end

  private

  def delete_if_no_participants
    @chat.destroy if @chat.users.count <= 1
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end

end
