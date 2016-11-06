class UserMailer < ApplicationMailer

  def signup_mail(user)
    @user = user
    @url = 'TestSite'
    mail(to: @user.email, subject: 'Thank you for signup')
  end

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset

  end
end
