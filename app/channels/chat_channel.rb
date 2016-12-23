# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel

  def subscribed
    stream_from 'ChatChannel'
  end

  # user has left the chat
  def unsubscribed
    $redis_connection.srem('participants', current_user.to_json)
    receive_members
  end

  # user has been joined to the chat
  def appear
    $redis_connection.sadd('participants', current_user.to_json)
    receive_members
  end

  # user has left the chat
  def leave
    $redis_connection.srem('participants', current_user.to_json)
    receive_members
  end


  private

  def receive_members
    members = $redis_connection.smembers('participants')
    members.map! { |item| JSON.parse(item) }

    ActionCable.server.broadcast self.class.name, members: members, type: 'members'
  end
end