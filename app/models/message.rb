class Message < ApplicationRecord
  has_and_belongs_to_many :unread_users,
                          join_table: 'unread_messages_users',
                          class_name: 'User'
  belongs_to :user
  belongs_to :chat, touch: true

  scope :for_chat, lambda { |chat|
    where(chat: chat)
  }

  scope :public_format, -> { includes(:user).order(created_at: :desc) }

  validates :text, length: { maximum: 255 }, presence: true

  after_create :create_cache

  def create_cache
    Rails.cache.write("#{self.class.name.demodulize.downcase}/#{id}/info", self)
  end

  def self.new_message(params, attributes = {})
    message = new(params)
    message.assign_attributes(attributes)
    message
  end

  # @param [Chat] chat
  def save_with_unread_users(chat)
    chat.messages << self
    unread_users << [chat.users]
  end
end
