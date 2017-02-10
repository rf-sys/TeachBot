class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_save :cache_cleaner

  def cache_cleaner
    Rails.cache.delete("#{self.class.name.demodulize.downcase}/#{self.id}/info")
  end
end
