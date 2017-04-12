# Central place for redis keys
class RedisGlobals
  class << self
    # contains list of courses id, recommended to user
    # @param [Integer] user_id
    # @return [Array]
    def user_recommendations(user_id)
      normalize_key("users/#{user_id}/recommended_courses")
    end

    # contains the most list of the most frequent tags, user has seen
    # @return [String]
    def user_popular_tags(user_id)
      normalize_key("users/#{user_id}/popular_tags")
    end

    # contains the most seen tags by the users
    # @return [String]
    def popular_tags
      normalize_key('popular_tags')
    end

    def test_env_suffix
      '_test'
    end

    private

    # @param [String] key
    # @return [String]
    def normalize_key(key)
      return key.concat(test_env_suffix) if Rails.env == 'test'
      key
    end
  end
end