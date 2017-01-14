module Throttle

  REDIS = $redis_connection


  module Interval

    class Base
      class << self
        def check_redis_connection(controller)
          begin
            REDIS.info
          rescue Redis::CannotConnectError
            return false
          end
          true
        end

        def check_test_env
          Rails.env == 'test'
        end

        def send_denied_response(controller, message)
          controller.error_message([message], 403)
        end
      end
    end

    # use when we register (message) new user
    class RequestInterval < Base

      SIGNUP_INTERVAL = 2 # seconds

      def self.before(controller)
        return true if check_test_env
        unless check_redis_connection(controller)
          return controller.error_message(['Error of connection to the server. Try again'], 403)
        end

        remote_ip = controller.request.remote_ip
        if too_many_attempts?(remote_ip)
          mark_ip(remote_ip)
          send_denied_response(controller, 'Too many attempts. Try in ' + SIGNUP_INTERVAL.to_s + ' seconds')
        else
          mark_ip(remote_ip)
        end
      end

      # return: bool
      def self.too_many_attempts?(remote_ip)
        if REDIS.exists("throttle[signup_interval][#{remote_ip}]")
          return true
        end
        false
      end



      # message a new cache of the ip
      def self.mark_ip(remote_ip)
        REDIS.set("throttle[signup_interval][#{remote_ip}]", true, ex: SIGNUP_INTERVAL)
      end

    end

    class SessionLocker < Base

      SESSION_LOCKER_INTERVAL = 2 # minutes
      MAX_ATTEMPTS = 5

      def self.before(controller)
        return true if check_test_env
        unless check_redis_connection(controller)
          return controller.error_message(['Error while connecting to the server. Try again'], 403)
        end

        remote_ip = controller.request.remote_ip

        if too_many_attempts?(remote_ip)
          send_denied_response(controller, 'Too many attempts. Try in ' + SESSION_LOCKER_INTERVAL.to_s + ' minutes')
        else
          add_attempt(remote_ip)
        end

      end

      def self.too_many_attempts?(remote_ip)
        unless REDIS.exists("throttle[login_locker][#{remote_ip}]")
          REDIS.set("throttle[login_locker][#{remote_ip}]", 0, ex: SESSION_LOCKER_INTERVAL.minutes)
        end

        return REDIS.get("throttle[login_locker][#{remote_ip}]").to_i >= MAX_ATTEMPTS
      end

      # message a new cache with updated values
      def self.add_attempt(remote_ip)

        # 'increment' resets expire time in cache...Cache simple doesn't delete after expire time

        REDIS.incr("throttle[login_locker][#{remote_ip}]")
      end

    end
  end

end