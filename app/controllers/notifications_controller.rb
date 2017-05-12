# represents notifications module at the header
class NotificationsController < ApplicationController
  include NotificationsHelper
  before_action :authenticate_user!
  before_action :related_to_current_user, only: [:destroy]

  before_action :set_json_format, only: [:index]

  # return user's notifications
  # @type POST
  # @return [Array]
  def index
    page = params[:page]
    @notifications = current_user.notifications.new_and_unread.paginate(page, 3)
  end

  # destroy notification
  # @type DELETE
  # @return
  def destroy
    if @notification.destroy
      render json: 'Ok'
    else
      error_message(@notification.errors.full_messages, 422)
    end
  end

  # return unread notifications for current_user
  # @type POST
  def count
    count = current_user.notifications.where(readed: false).size
    render json: { count: count }
  end

  # mark all unread notifications as read
  # @type PUT
  def mark_as_read
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

  def set_json_format
    request.format = :json
  end
end
