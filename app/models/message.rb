class Message < ApplicationRecord
  has_and_belongs_to_many :unread_users, join_table: 'unread_messages_users', class_name: 'User'
  belongs_to :user
  belongs_to :chat, touch: true

  scope :for_public_chat, -> (chat) do
    where(chat: chat).includes(:user).order(created_at: :desc)
  end

  scope :for_chat_id, -> (chat_id) do
    where(chat_id: chat_id)
  end

  validates :text, length: {maximum: 255}, presence: true

  after_create :create_cache

  def create_cache
    Rails.cache.write("#{self.class.name.demodulize.downcase}/#{self.id}/info", self)
  end

  def self.new_message(params, attributes = {})
    message = self.new(params)
    message.assign_attributes(attributes)
    message
  end

  # @param [Chat] chat
  def save_with_unread_users(chat)
    chat.messages << self
    self.unread_users << [chat.users]
  end
end
