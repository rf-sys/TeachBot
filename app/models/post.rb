class Post < ApplicationRecord
  belongs_to :user
  validates :title, :text, presence: true
  validates :title, length: {maximum: 30}
  validates :text, length: {maximum: 255}

end
