class NotificationJob < ApplicationJob
  queue_as :notifications

  def perform(recipient_id, notification_id)
    recipient ||= User.find_by(id: recipient_id)
    notification ||= Notification.find_by(id: notification_id)

    return unless recipient.present?
    return unless notification.present?

    NotificationsChannel.broadcast_notification_to(recipient, notification)
  end
end
