module NotificationsHelper
  def notifications(user)
    user.notifications.order(created_at: :desc)
  end
end