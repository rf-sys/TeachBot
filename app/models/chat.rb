class Chat < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :messages, dependent: :destroy

  belongs_to :initiator, foreign_key: 'initiator_id', class_name: 'User'
  belongs_to :recipient, foreign_key: 'recipient_id', class_name: 'User'

  scope :between_users, -> (user_1, user_2) do
    where(
        '(initiator_id = ? AND recipient_id = ?) OR (initiator_id = ? AND recipient_id = ?)',
        user_1, user_2, user_2, user_1
    ).where(public_chat: false).joins(:users).group('chats.id').having('count(users.id) = 2')
  end

  scope :with_users_and_messages, -> { includes(:users, messages: [:user]).distinct }

  after_create :add_participants


  def add_participants
    self.users << [self.initiator, self.recipient]
  end

  def add_participant(user)
    self.users << user
    self.touch
  end

  def kick_participant(user)
    self.users.delete(user)
    self.touch
  end

  class << self
    def find_or_initialize_between(initiator, recipient)
      chat = self.between_users(initiator, recipient).first
      unless chat
        chat = self.new(initiator: initiator, recipient: recipient)
      end
      chat
    end
  end
end
