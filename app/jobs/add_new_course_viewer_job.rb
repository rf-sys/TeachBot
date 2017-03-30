class AddNewCourseViewerJob < ApplicationJob
  queue_as :default

  # @param [String] ip
  # @param [Integer] course_id
  def perform(ip, course_id)
    course = Course.find(course_id)
    return unless course.present?

    redis = Redis.new

    recent_visit = redis.get("users/#{ip}/courses/#{course.id}/visited_at")

    return if recent_visit.present?

    redis.set("users/#{ip}/courses/#{course.id}/visited_at",
              Time.now.to_i, ex: 24.hours)

    views = course.views

    course.update_attributes(views: views + 1)
  end
end
