class Tag < ApplicationRecord
  validates :name, length: { maximum: 20 }
end
