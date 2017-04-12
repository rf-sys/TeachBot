module Services
  module Access
    # Used to prevent visiting abuse
    class RecentVisit
      def initialize(ip, entity)
        @ip = ip
        @entity = entity
        @redis = Redis.new
      end

      def alive?
        !@redis.get(visit_key).nil?
      end

      def mark_recent_visit_until(time)
        @redis.set(visit_key, 1, ex: time.to_time.to_i)
      end

      def clear
        @redis.del(visit_key)
      end

      private

      def visit_key
        entity_key = @entity.class.name.downcase.pluralize

        "users/#{@ip}/#{entity_key}/#{@entity.id}/visit"
      end
    end
  end
end