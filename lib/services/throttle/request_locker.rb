module Services
  module Throttle
    class RequestLocker < Base
      alias :request_locker_instance throttle_instance

      protected

      def check
        raise 'Too many attempts' if too_many_attempts?
      end

      private

      def too_many_attempts?
        return true if request_locker_instance.present?


        add_request_attempt
        false
      end

      def redis_key
        RedisGlobals.throttle_request_locker(@action, @ip)
      end

      def add_request_attempt
        key = RedisGlobals.throttle_request_locker_attempts(@action, @ip)
        attempts = RedisSingleton.instance.incr(key)

        create_request_locker_instance if attempts >= @options[:attempts]
      end

      def create_request_locker_instance
        clear_attempts
        RedisSingleton.instance.set(redis_key, 1, ex: @options[:time].to_i)
      end

      def clear_attempts
        key = RedisGlobals.throttle_request_locker_attempts(@action, @ip)
        RedisSingleton.instance.set(key, 0)
      end
    end
  end
end
