class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_destroy :cache_cleaner
  after_update_commit :cache_cleaner

  def cache_cleaner
    Rails.cache.delete("#{self.class.name.demodulize.downcase}/#{self.id}/info")
  end
end
