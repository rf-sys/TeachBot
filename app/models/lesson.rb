class Lesson < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :course, touch: true
end
