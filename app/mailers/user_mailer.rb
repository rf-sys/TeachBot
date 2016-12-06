class UserMailer < ApplicationMailer

  def account_activation(user, token)
    @user = user
    @activation_token = token
    mail to: user.email, subject: 'Account activation'
  end

  def password_reset

  end
end
