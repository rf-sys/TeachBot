module Services
  module Throttle
    class Base
      # entry point for Throttle
      # @param [ApplicationController] controller
      # @param [Hash] options
      def initialize(controller, **options)
        @action = controller.controller_name + ':' + controller.action_name
        @options = options
        @ip = controller.request.remote_ip
        ping_redis_server
        check
      end

      private

      def ping_redis_server
        RedisSingleton.instance.ping
      end

      def throttle_instance
        RedisSingleton.instance.get(redis_key)
      end
    end
  end
end
