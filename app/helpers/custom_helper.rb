module CustomHelper
  module Responses
    def error_message(errors = [], status)
      render :json => {:errors => errors}, status: status
    end
  end

  module Cache
    # flexible cache to prevent repeating Rails.cache.fetch
    # @param [ApplicationRecord] klass
    def fetch_cache(klass, id, key = 'id')
      class_name = klass.name.demodulize.downcase
      Rails.cache.fetch("#{class_name}/#{id}/#{key}") do
        if block_given?
          yield
        else
          klass.find(id)
        end
      end
    end
  end
end