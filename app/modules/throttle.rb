module Throttle

  CACHE = Rails.cache

  module Interval

    # use when we register (create) new user
    class RequestInterval

      SIGNUP_INTERVAL = 2 # seconds

      def self.before(controller)

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
        CACHE.exist?('throttle_' + remote_ip.to_s)
      end

      def self.send_denied_response(controller)
        controller.render :json => 'Too many attempts. Try in ' + SIGNUP_INTERVAL.to_s + ' seconds', status: 403
      end

      # create a new cache of the ip
      def self.mark_ip(remote_ip)
        CACHE.write('throttle_' + remote_ip.to_s, remote_ip, expires_in: SIGNUP_INTERVAL.seconds)
      end

    end

    class SessionLocker

      SESSION_LOCKER_INTERVAL = 2 # minutes
      MAX_ATTEMPTS = 5

      def self.before(controller)
        remote_ip = controller.request.remote_ip

        if too_many_attempts?(remote_ip)
          send_denied_response(controller)
        else
          add_attempt(remote_ip)
        end

      end

      def self.too_many_attempts?(remote_ip)

        unless CACHE.exist?('locker_throttle_' + remote_ip)
          CACHE.write('locker_throttle_' + remote_ip, 0, expires_in: SESSION_LOCKER_INTERVAL.minutes)
        end

        return CACHE.read('locker_throttle_' + remote_ip) >= MAX_ATTEMPTS
      end

      def self.send_denied_response(controller)
        controller.render :json => 'Too many attempts. Try in ' + SESSION_LOCKER_INTERVAL.to_s + ' minutes', status: 403
      end

      # create a new cache with updated values
      def self.add_attempt(remote_ip)

        # 'increment' resets expire time in cache...Cache simple doesn't delete after expire time

       i = CACHE.read('locker_throttle_' + remote_ip)+1

       CACHE.write('locker_throttle_' + remote_ip, i, expires_in: SESSION_LOCKER_INTERVAL.minutes)
      end

    end
  end

end