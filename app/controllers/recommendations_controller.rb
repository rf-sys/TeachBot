class RecommendationsController < ApplicationController
  before_action :authenticate_user!

  def index
    key = RedisGlobals.user_recommendations(current_user.id)
    courses_ids = RedisSingleton.instance.zrange(key, 0, 6)
    @recommendations = Course.find(courses_ids)
  end
end
