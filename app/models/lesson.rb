class Lesson < ApplicationRecord
  belongs_to :user, touch: true
end
