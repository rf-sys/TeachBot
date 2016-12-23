class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  validates :text, length: {maximum: 255}, presence: true
end
