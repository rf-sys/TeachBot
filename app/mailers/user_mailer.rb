class UserMailer < ApplicationMailer
  def account_activation(user_id, token)
    @user ||= User.find_by(id: user_id)

    return if @user.blank?

    @activation_token ||= token
    mail to: @user.email, subject: 'Account activation'
  end

  def password_reset; end
end
