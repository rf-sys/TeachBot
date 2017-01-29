# business logic
module Services
  module UseCases
    module Course
      module UpdatePosterService
        class UpdatePoster
          require_dependency 'uploaders/poster_uploader'

          # init adapters
          # @param [Repositories::CourseRepository] course_repository
          # @param [CoursesController] listener
          def initialize(course_repository, listener)
            @course_repository = course_repository
            @listener = listener
          end

          # update course poster
          # @param [Course] course
          # @param [File] poster
          def update(course, poster)
            uploader = PosterUploader.new(poster, course.id)
            if uploader.has_valid_file? && uploader.store
              @course_repository.update_poster_attribute(course, uploader.url)
              @listener.render :json => {
                  :message => 'Poster has been created successfully',
                  :url => uploader.url
              }, status: :ok
            else
              @listener.error_message([uploader.error], 422)
            end
          end
        end
      end
    end
  end
end

