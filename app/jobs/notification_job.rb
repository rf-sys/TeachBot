class NotificationJob < ApplicationJob
  queue_as :notifications

  def perform(recipient, notification)
    NotificationsChannel.broadcast_notification_to(recipient, notification)
  end
end
