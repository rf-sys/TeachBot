class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # provide paginate scope to get rid of page.per
  scope :paginate, ->(page, per) { page(page).per(per) }

  before_commit :cache_cleaner

  def cache_cleaner
    normalized_class_name = self.class.name.demodulize.downcase
    Rails.cache.delete("#{normalized_class_name}/#{id}/id")

    if self.class.respond_to? :friendly
      Rails.cache.delete("#{normalized_class_name}/#{friendly_id}/slug")
    end
  end
end
