class Message < ApplicationRecord
  has_and_belongs_to_many :unread_users, join_table: 'unread_messages_users', class_name: 'User'
  belongs_to :user
  belongs_to :chat, touch: true
  validates :text, length: {maximum: 255}, presence: true

  after_create :create_cache

  def create_cache
    Rails.cache.write("#{self.class.name.demodulize.downcase}/#{self.id}/info", self)
  end
end
