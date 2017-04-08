class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true, counter_cache: :tags_count

  validates :name, length: { maximum: 30 }
end
