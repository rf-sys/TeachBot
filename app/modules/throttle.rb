module Throttle

  REDIS = Redis.new


  module Interval

    # use when we register (create) new user
    class RequestInterval

      SIGNUP_INTERVAL = 2 # seconds

      def self.before(controller)

        return true if Rails.env == 'test'

        remote_ip = controller.request.remote_ip
        if too_many_attempts?(remote_ip)
          mark_ip(remote_ip)
          send_denied_response(controller)
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

      def self.send_denied_response(controller)
        controller.render :json => 'Too many attempts. Try in ' + SIGNUP_INTERVAL.to_s + ' seconds', status: 403
      end

      # create a new cache of the ip
      def self.mark_ip(remote_ip)
        REDIS.set("throttle[signup_interval][#{remote_ip}]", true, ex: SIGNUP_INTERVAL)
      end

    end

    class SessionLocker

      SESSION_LOCKER_INTERVAL = 2 # minutes
      MAX_ATTEMPTS = 5

      def self.before(controller)

        return true if Rails.env == 'test'

        remote_ip = controller.request.remote_ip

        if too_many_attempts?(remote_ip)
          send_denied_response(controller)
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

      def self.send_denied_response(controller)
        controller.render :json => 'Too many attempts. Try in ' + SESSION_LOCKER_INTERVAL.to_s + ' minutes', status: 403
      end

      # create a new cache with updated values
      def self.add_attempt(remote_ip)

        # 'increment' resets expire time in cache...Cache simple doesn't delete after expire time

        REDIS.incr("throttle[login_locker][#{remote_ip}]")
      end

    end
  end

end