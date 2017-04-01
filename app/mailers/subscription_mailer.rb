class SubscriptionMailer < ApplicationMailer
  def new_lesson_email(course_id, lesson_id, user_id)

    @course ||= Course.find_by(id: course_id)
    @lesson ||= Lesson.find_by(id: lesson_id)
    user ||= User.find_by(id: user_id)

    return unless @course.present?
    return unless @lesson.present?
    return unless user.present?

    mail(to: user.email, subject: 'New lesson has been created!')
  end
end
