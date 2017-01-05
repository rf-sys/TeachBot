class UnreadMessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  class << self
    def add_message(user)
      UnreadMessagesChannel.broadcast_to(user, type: 'unread_messages:add')
    end

    def remove_message(user)
      UnreadMessagesChannel.broadcast_to(user, type: 'unread_messages:remove')
    end
  end
end
