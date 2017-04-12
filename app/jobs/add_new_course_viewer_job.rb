class AddNewCourseViewerJob < ApplicationJob
  include Services::Access

  queue_as :default

  # @param [Integer] course_id
  def perform(course_id)
    course ||= Course.find_by(id: course_id)

    return unless course.present?

    views = course.views

    course.update_attributes(views: views + 1)
  end
end
