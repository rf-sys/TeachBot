class Lesson < ApplicationRecord
  belongs_to :course, touch: true

  validates :title, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 500} # temporarily
end
