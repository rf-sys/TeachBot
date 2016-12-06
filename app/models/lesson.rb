class Lesson < ApplicationRecord
  belongs_to :course, touch: true
end
