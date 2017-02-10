class AddNewCourseViewerJob < ApplicationJob
  queue_as :default

  def perform(ip, course_id)
    visited = $redis_connection.get("users/#{ip}/courses/#{course_id}/visited")

    if visited.blank?
      $redis_connection.set("users/#{ip}/courses/#{course_id}/visited", Time.now.to_i, ex: 24.hours)
      $redis_connection.incr("courses/#{course_id}/visitors")
    end
  end
end
