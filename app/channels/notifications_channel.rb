class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  class << self
    def broadcast_notification_to(user, notification)
      NotificationsChannel.broadcast_to user, notification: notification
    end
  end
end
