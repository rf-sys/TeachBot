class Message < ApplicationRecord
  belongs_to :user

  validates :text, length: {maximum: 255}, presence: true
end
