class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def cache_cleaner
    Rails.cache.delete("#{self.class.name.demodulize.downcase}/#{self.id}/info")
  end
end
