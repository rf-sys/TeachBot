# methods, that helps to work with Course model
module CoursesHelper
  # @param [Course] course
  def access_to_course?(course, auth_user = nil)
    @course = course

    # check if the course is public and published
    return true if @course.public? && @course.published?

    # if the course isn't public or published, we should check
    # if auth_user is author of the course, so author don't need any checks
    return true if @course.author == auth_user

    # if auth_user isn't author, we need to check:
    # - if the auth_user is participant of the course if it's private
    # - we need be sure that the course is flagged as published
    # to restrict access to anyone, except author,
    # even if the user is a participant of private course
    return true if course_participant?(auth_user) && @course.published?

    false
  end

  # prepare course tags param to be saved as association
  def course_tags(params)
    return [] unless params.fetch(:course, {}).fetch(:tags_list, false).present?

    tags_param = params[:course][:tags_list].split(',')

    tags_param.map! { |tag| { name: tag } }
  end

  private

  def course_participant?(auth_user)
    @course.participants.include?(auth_user)
  end

  def visited_recently?(ip, course_id)
    recent_visit = $redis_connection.get("#{ip}/courses/#{course_id}/visited")

    return true if recent_visit.present?

    mark_recent_visit(ip, course_id)
    false
  end

  def mark_recent_visit(ip, course_id)
    $redis_connection.set("#{ip}/courses/#{course_id}/visited",
                          Time.now.to_i, ex: 24.hours)
    true
  end
end
