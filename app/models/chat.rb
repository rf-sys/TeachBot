class Chat < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: 'user'
  has_many :messages, dependent: :destroy

  belongs_to :initiator, foreign_key: 'initiator_id', class_name: 'User'
  belongs_to :recipient, foreign_key: 'recipient_id', class_name: 'User'

  scope :between_users, lambda { |user_1, user_2|
    where(
      '(initiator_id = ? AND recipient_id = ?) OR (initiator_id = ? AND recipient_id = ?)',
      user_1, user_2, user_2, user_1
    ).where(public_chat: false).joins(:members).group('chats.id').having('count(users.id) = 2')
  }

  scope :with_users_and_messages, -> { includes(:users, messages: [:user]).distinct }

  after_create :add_participants

  def add_participants
    members << [initiator, recipient]
  end

  def add_participant(user)
    members << user
    touch
  end

  def kick_participant(user)
    members.delete(user)
    touch
  end

  class << self
    def find_or_initialize_between(initiator, recipient)
      chat = between_users(initiator, recipient).first
      chat = new(initiator: initiator, recipient: recipient) unless chat
      chat
    end
  end
end
