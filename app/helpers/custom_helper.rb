module CustomHelper
  module Cache
    # flexible cache to prevent repeating Rails.cache.fetch
    # @param [ApplicationRecord] klass
    def fetch_cache(klass, id, key = 'id', options = {})
      class_name = klass.name.demodulize.downcase
      Rails.cache.fetch("#{class_name}/#{id}/#{key}", options) do
        if block_given?
          yield
        else
          klass.find_by(id: id)
        end
      end
    end
  end

  module Redis
    def check_redis_connection
      begin
        RedisSingleton.instance.ping
      rescue Redis::CannotConnectError
        return false
      end
      true
    end
  end
end
