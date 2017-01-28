# business logic
module Services
  module UseCases
    module Course
      module UpdatePosterService
        class UpdatePoster
          include FileHelper::Uploader

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
            uploader = ImageUploader.new(course, 'courses_posters', poster, {max_size: 1024})
            if @course_repository.save_poster(uploader)
              path = uploader.path + '?updated=' + Time.now.to_i.to_s
              @course_repository.update_poster_attribute(course, path)
              @listener.render :json => {:message => 'Poster has been created successfully', :url => path}, status: :ok
            else
              @listener.error_message([uploader.error], 422)
            end
          end
        end
      end
    end
  end
end

