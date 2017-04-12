class IncreaseTagsPopularityJob < ApplicationJob
  queue_as :default

  def perform(tags_names)
    return unless tags_names.any?

    tags_names.uniq!

    redis = Redis.new
    key = RedisGlobals.popular_tags

    tags_names.each do |tag|
      redis.zincrby(key, 1, tag)
    end
  end
end
