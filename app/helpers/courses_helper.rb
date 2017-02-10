module CoursesHelper
  # @param [Course] course
  def have_access_to_private_course(course)
    unless course.public
      unless current_user
       return false
      end
      if course.author == current_user
        return true
      end
      unless course.participants.find_by_id(current_user.id).present?
        return false
      end
      true
    end
    true
  end

  # @param [Course] course
  def unpublished_and_user_is_author(course)
    unless course.published
      unless current_user == course.author
        return false
      end
    end
    true
  end
end