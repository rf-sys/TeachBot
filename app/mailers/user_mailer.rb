class UserMailer < ApplicationMailer

  def signup_mail(user)
    @user = user
    @url = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Thank you for signup')
  end
end
