module CustomHelpers
  module Responses
    def error_message(errors, status)
       render :json => {:errors => errors}, status: status
    end
  end

  module Cache
    # flexible cache to prevent repeating Rails.cache.fetch
    # @param [ApplicationRecord] klass
    def get_from_cache(klass, id, option = 'info')
      class_name = klass.name.demodulize.downcase
      Rails.cache.fetch("#{class_name}/#{id}/#{option}") do
        if block_given?
          yield
        else
          klass.find(id)
        end
      end
    end
  end
end