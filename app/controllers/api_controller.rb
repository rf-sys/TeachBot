class ApiController < ApplicationController
  require 'net/http'
  include ApiHelper::Facebook, MessagesHelper

  before_action :require_guest, only: [:facebook_oauth]
  before_action :require_user, only: [
      :conversations, :conversation_messages, :notifications, :unread_messages_count, :unread_messages,
      :mark_all_messages_as_read
  ]

  def bot
    bot = TeachBot::Commands.new(request)
    render :json => bot.generate_response, status: bot.status
  end

  # facebook auth service
  def facebook_oauth

    return fb_validation_error unless code_exist?(request[:code])

    access_token = get_access_token request[:code]

    return fb_validation_error unless valid_access_token?(access_token['access_token'])

    fb_user = get_user_data(access_token['access_token'])

    begin
      user = create_or_initialize_user(fb_user)
    rescue StandardError => e
      return fb_validation_error(e.message)
    end

    log_in user

    redirect_to root_path
  end

  # get user's subscriptions, devided by pagination
  def subscriptions_pagination
    user = get_from_cache(User, params[:user_id])
    subscriptions = user.subscriptions.page(params[:page]).per(1)
    render :partial => 'courses/pagination', locals: {subscriptions: subscriptions}
  end

  # return courses, created by specific user and divided by pagination
  def user_courses_pagination
    @user = get_from_cache(User, params[:user_id])
    @courses = @user.courses.page(params[:page]).per(1)
  end

  # return subscribers of the course
  def subscribers
    @course = Course.find(params[:id])
  end

  # find user by username and return as json
  # @return [Object]
  def find_user_by_username
    if params[:username]
      users = User.select(:id, :username, :avatar).where('username LIKE ?', "%#{params[:username]}%").limit(10)
      render :json => {users: users}
    end
  end

  # @return [Object]
  def conversations
    @chats = current_user.chats.with_users_and_messages
  end

  # get messages, related to specific Chat with pagination
  # @return [Object]
  def conversation_messages
    chat = get_from_cache(Chat, params[:id])

    unless current_user_related_to_chat(chat)
      error_message(['Forbidden'], 403)
    end
    @messages = chat.messages.includes(:unread_users).reverse_order.page(params[:page]).per(2)
  end


  # return unread notifications for current_user
  # @return [Object]
  def unread_notifications_count
    count = current_user.notifications.where(notifications: {readed: false}).count
    render :json => {count: count}
  end

  # return count of unread messages
  def unread_messages_count
    count = current_user.unread_messages.count

    render :json => {count: count}
  end

  # return unread messages
  def unread_messages
    @messages = current_user.unread_messages.includes(:user).where(:messages => {chat_id: params[:chat_id]})
  end

  # return user's notifications
  # @return [Object]
  def notifications
    @notifications = Rails.cache.fetch('api/notifications?user=' + current_user.cache_key) do
      current_user.notifications
    end
  end


  # delete provided message from current user unread messages
  def mark_message_as_read
    message = get_from_cache(Message, params[:id])
    chat_id = message.chat_id
    message_id = message.id

    if current_user.unread_messages.delete(message)
      UnreadMessagesChannel.remove_message(current_user, chat_id, message_id)
      render :json => {status: 'done'}, status: 200
    else
      render :json => 'Something went wrong', status: 422
    end
  end

  # mark all messages as read
  def mark_all_messages_as_read
    messages = current_user.unread_messages.where(chat_id: params[:chat_id])

    if current_user.unread_messages.delete(messages)
      render :json => {status: 'done'}, status: 200
    else
      render :json => 'Something went wrong', status: 422
    end
  end


  private

  def fb_validation_error(error = 'Something went wrong. Try login with facebook again')
    redirect_to root_path, flash: {danger_notice: error}
  end


  # access check 'if current_user is related to provided chat'
  # @param [Chat] chat
  def current_user_related_to_chat(chat)
    return true if chat.public_chat # public_chat
    chat.users.include?(current_user)
  end

  def message_belongs_to_current(message)
    message.user_id == current_user.id
  end
end
