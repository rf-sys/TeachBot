class GenerateRecommendedCoursesJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)

    return unless user.present?

    redis = RedisSingleton.instance
    popular_tags_key = RedisGlobals.user_popular_tags(user.id)
    user_recommendations_key = RedisGlobals.user_recommendations(user.id)

    tags = redis.zrevrange(popular_tags_key, 0, 9)

    courses = Course.joins(:tags).where(tags: { name: tags })
                    .group('courses.id').group('tags.taggable_id')
                    .order('COUNT(*) DESC').limit(10)

    return unless courses.any?

    courses.order!(views: :desc)

    course_ids = normalize_ids(courses)

    redis.zadd(user_recommendations_key, course_ids)
  end

  private

  def normalize_ids(courses)
    course_ids_prepare = []

    courses.each_with_index do |course, index|
      course_ids_prepare << [index + 1, course.id]
    end

    course_ids_prepare
  end
end
