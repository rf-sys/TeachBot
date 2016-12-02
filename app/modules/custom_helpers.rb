module CustomHelpers
  class Responses
    def send_fail_json(errors)
      render :json => {:error => errors}, status: 422
    end
  end

  class Cache
    # flexible cache to prevent repeating Rails.cache.fetch
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