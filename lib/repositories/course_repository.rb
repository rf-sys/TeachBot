module Repositories
  module CourseRepository
    extend self

    def save_poster(file)
      if file.valid?
        file.save
        true
      else
        false
      end
    end

    def update_poster_attribute(course, path)
      course.update_attribute('poster', path)
    end
  end
end
