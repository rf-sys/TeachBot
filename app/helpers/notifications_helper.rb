module NotificationsHelper
  def user_notifications(user)
    user.notifications.order(created_at: :desc)
  end
end