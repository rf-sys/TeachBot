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
  private

  def course_participant?(auth_user)
    @course.participants.include?(auth_user)
  end
end
