class NotificationsController < ApplicationController
  before_action :related_to_current_user

  # destroy notification
  # @return
  def destroy
    if @notification.destroy
      render :json => 'Ok'
    else
      error_message(@notification.errors.full_messages, 422)
    end
  end

  private

  # check if notification belongs to current_user
  def related_to_current_user
    unless (@notification = Notification.find_by_id(params[:id]))
      return error_message(['Notification not found'], 404)
    end

    unless @notification.user == current_user
      error_message(['Forbidden'], 403)
    end
  end
end
