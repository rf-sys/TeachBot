class AddNewCourseViewerJob < ApplicationJob
  queue_as :default

  def perform(ip, course_id)
    redis = Redis.new

    visited = redis.get("users/#{ip}/courses/#{course_id}/visited")

    if visited.blank?
      redis.set("users/#{ip}/courses/#{course_id}/visited", Time.now.to_i, ex: 24.hours)
      redis.incr("courses/#{course_id}/visitors")
    end
  end
end
