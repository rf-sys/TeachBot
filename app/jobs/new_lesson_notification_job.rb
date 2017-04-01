class NewLessonNotificationJob < ApplicationJob
  queue_as :default

  def perform(course_id, lesson_id)
    course ||= Course.find_by(id: course_id)
    lesson ||= Lesson.find_by(id: lesson_id)

    return unless course.present?
    return unless lesson.present?

    @subscribers = User.course_subscribers(course)
    notifications = create_notifications(@subscribers, course, lesson)
    deliver_notifications(notifications)
    deliver_emails(@subscribers, course, lesson)
  end

  private

  def create_notifications(users, course, lesson)
    notifications = []
    users.each { |u| notifications << generate_notification(u, course, lesson) }
    Notification.import notifications
    notifications
  end

  def generate_notification(user, course, lesson)
   notification = notification_template(course, lesson)
   notification.user = user
   notification
  end

  def notification_template(course, lesson)
    Notification.generate(
        "New lesson: #{lesson.title}",
        "New lesson of the course \"#{course.title}\" has been created",
        "/courses/#{course.friendly_id}/lessons/#{lesson.friendly_id}"
    )
  end

  def deliver_notifications(notifications)
    notifications.each do |notification|
      NotificationJob.perform_later(notification.user.id, notification.id)
    end
  end

  def deliver_emails(subscribers, course, lesson)
    subscribers.each do |user|
      SubscriptionMailer.new_lesson_email(course.id, lesson.id, user.id).deliver_later
    end
  end
end
