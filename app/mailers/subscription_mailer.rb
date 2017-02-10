class SubscriptionMailer < ApplicationMailer
  def new_lesson_email(course, lesson, user)
    @course ||= course
    @lesson ||= lesson
    mail(to: user.email, subject: 'New lesson has been created!')
  end
end
