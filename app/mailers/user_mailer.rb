class UserMailer < ApplicationMailer

  def signup_mail(user)
    @user = user
    @url = 'TestSite'
    mail(to: @user.email, subject: 'Thank you for signup')
  end
end
