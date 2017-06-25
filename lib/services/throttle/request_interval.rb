module Services
  module Throttle
    class RequestInterval < Base
      alias :request_interval_instance throttle_instance

      protected

      def check
        raise 'Too frequently request' if too_frequently_request?
      end

      private

      def too_frequently_request?
        return true if request_interval_instance.present?

        create_interval
        false
      end

      def redis_key
        RedisGlobals.throttle_request_interval(@action.to_s, @ip)
      end

      def create_interval
        RedisSingleton.instance.set(redis_key, 1, ex: @options[:time].to_i)
      end
    end
  end
end
