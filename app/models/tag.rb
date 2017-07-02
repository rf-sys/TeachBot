class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true, counter_cache: :tags_count, touch: true, optional: true

  validates :name, length: { maximum: 30 }
end
