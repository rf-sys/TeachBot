# represents notifications module at the header
class NotificationsController < ApplicationController
  include NotificationsHelper
  before_action :require_user
  before_action :related_to_current_user, only: [:destroy]

  # return user's notifications
  # @return [Array]
  def index
    page = params[:page]
    @notifications = notifications(current_user).paginate(page, 4)
  end

  # destroy notification
  # @return
  def destroy
    if @notification.destroy
      render json: 'Ok'
    else
      error_message(@notification.errors.full_messages, 422)
    end
  end

  # return unread notifications for current_user
  # @return [Object]
  def count
    count = current_user.notifications.where(readed: false).size
    render json: { count: count }
  end

  def mark_all_as_read
    notifications = current_user.notifications.where(readed: false)
    # we don't pass user's data, so rubocop warning is surplus
    notifications.update_all(readed: true)  # rubocop:disable all
    render json: { message: 'ok' }
  end

  private

  # check if notification belongs to current_user
  def related_to_current_user
    unless (@notification = Notification.find_by(id: params[:id]))
      return error_message(['Notification not found'], 404)
    end

    error_message(['Forbidden'], 403) unless @notification.user == current_user
  end
end
