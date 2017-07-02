module Repositories
  module CourseRepository
    extend self

    def update_poster_attribute(course, path)
      course.update_attribute('poster', path)
    end
  end
end
