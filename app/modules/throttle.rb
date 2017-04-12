module Throttle

  module Interval

    class Base
      class << self

        def run(controller, key, options = {})
          before(controller, key, options)
        end

        def check_redis_connection
          begin
            RedisSingleton.instance.info
          rescue Redis::CannotConnectError
            return false
          end
          true
        end

        def send_denied_response(controller, message)
          controller.error_message([message], 403)
        end
      end
    end

    # use when we register (message) new user
    class RequestInterval < Base

      @format = :seconds
      @time = 2
      @interval = 2.send(@format) # seconds

      def self.before(controller, key, options = {})
        @key = key

        config(options)

        unless check_redis_connection
          return controller.error_message(['Error of connection to the server. Try again'], 403)
        end

        remote_ip = controller.request.remote_ip

        if too_many_attempts?(remote_ip)
          send_denied_response(controller, "Too many attempts. Try in #{output_time}")
        end

        mark_ip(remote_ip)
      end

      # return: bool
      def self.too_many_attempts?(remote_ip)
        if RedisSingleton.instance.exists("throttle[#{@key}][#{remote_ip}]")
          return true
        end
        false
      end



      # message a new cache of the ip
      def self.mark_ip(remote_ip)
        RedisSingleton.instance.set("throttle[#{@key}][#{remote_ip}]", true, ex: @interval)
      end

      def self.config(options)
        @format = options[:format] if options[:format]
        @interval = options[:interval].send(@format) if options[:interval]
        @time = options[:interval] if options[:interval]
      end

      def self.output_time
        "#{@time} #{@format}"
      end

    end

    class SessionLocker < Base

      @interval = 2 # minutes
      @max_attempts = 5

      def self.before(controller, key, options = {})

        @key = key

        config(options)

        unless check_redis_connection
          return controller.error_message(['Error while connecting to the server. Try again'], 403)
        end

        remote_ip = controller.request.remote_ip

        if too_many_attempts?(remote_ip)
          return send_denied_response(controller, 'Too many attempts. Try in ' + @interval.to_s + ' minutes')
        else
          add_attempt(remote_ip)
        end

      end

      def self.too_many_attempts?(remote_ip)
        unless RedisSingleton.instance.exists("throttle[#{@key}][#{remote_ip}]")
          RedisSingleton.instance.set("throttle[#{@key}][#{remote_ip}]", 0, ex: @interval.minutes)
        end

        RedisSingleton.instance.get("throttle[#{@key}][#{remote_ip}]").to_i >= @max_attempts
      end

      # message a new cache with updated values
      def self.add_attempt(remote_ip)

        # 'increment' resets expire time in cache...Cache simple doesn't delete after expire time

        RedisSingleton.instance.incr("throttle[#{@key}][#{remote_ip}]")
      end

      def self.config(options)
        options.each do |key, val|
          instance_variable_set("@#{key}".to_sym, val)
        end
      end

    end
  end

end