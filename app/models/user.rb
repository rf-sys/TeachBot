class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
  searchkick batch_size: 5
  rolify
  require 'validators/EmailValidator'
  require 'sendgrid-ruby'
  include SendGrid
  include BCrypt
  # to get 'authenticate method' and 'password='.
  # 'password=' generates password_digest
  include ActiveModel::SecurePassword::InstanceMethodsOnActivation

  has_one :profile, dependent: :destroy, inverse_of: :user
  has_many :lessons
  has_many :recent_lessons, -> { order('created_at DESC').limit(2) }, class_name: 'Lesson'
  has_many :posts, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :courses, foreign_key: 'author_id'

  has_many :paginate_courses, -> { order('created_at ASC').limit(2) },
           class_name: 'Course', foreign_key: 'author_id'

  has_many :notifications, dependent: :destroy

  has_and_belongs_to_many :chats

  has_many :accesses, dependent: :destroy

  has_many :accessed_courses, through: :accesses, source: :accessable, source_type: 'Course'

  has_many :subscriptions, dependent: :destroy

  has_many :subscriptions_to_courses, through: :subscriptions, source: :subscribeable,
      source_type: 'Course'

  has_and_belongs_to_many :unread_messages, join_table: 'unread_messages_users', class_name: 'Message'

  scope :select_profile_attr, -> { select(:id, :username, :email, :avatar, :updated_at) }
  scope :find_with_profile, ->(id) { includes(:profile).find(id) }
  scope :course_subscribers, ->(course) do
    includes(:subscriptions).where(subscriptions: { subscribeable_type: 'Course', subscribeable_id: course.id })
  end

  scope :where_username_like, ->(username) do
    where('username LIKE ?', "%#{username}%").limit(10)
  end

  scope :public_fields, -> { select(:id, :username, :avatar) }
  attr_accessor :remember_token, :activation_token
  accepts_nested_attributes_for :profile, reject_if: :all_blank

  validates :username, :email, presence: true, uniqueness: true
  validates :username, length: { maximum: 30 }
  validates :email, email: true, length: { maximum: 100 }
  validates :password, length: (6..32), confirmation: true, if: :setting_password?

  before_save :downcase_email

  before_create :create_activation_digest

  before_destroy :delete_avatar, :delete_unread_messages

  after_create :generate_profile, :assign_default_role

  after_update :touch_chats

  after_save :clean_user_courses_cache

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  # delete avatar before delete user
  def delete_avatar
    avatar = $bucket.object("uploads/avatars/#{id}.jpg")
    avatar.delete if avatar.exists?
  end

  def delete_unread_messages
    unread_messages.destroy_all
  end

  # generate and store token to the database
  def remember
    self.remember_token = User.new_token # message new string which is like a token
    update_attributes(remember_digest: User.digest(remember_token)) # save a hash of the token above in the DB
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attributes(remember_digest: nil)
  end

  # Activates an account.
  def activate
    update_attributes(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self, activation_token).deliver_later
  end

  # Regenerate activation token and digest and send email
  def resend_activation_email
    create_activation_digest
    save
    send_activation_email
  end

  def attach_notification(notification)
    notifications << notification
  end

  def search_data
    {
      username: username
    }
  end

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      User.where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first_or_create! do |user|
        user.username = auth_hash[:info][:name]
        user.email = auth_hash[:info][:email]
        user.avatar = auth_hash[:info][:image]
        user.activated = true
      end
    end
  end

  private

  def should_generate_new_friendly_id?
    username_changed?
  end

  def setting_password?
    password || password_confirmation
  end

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def generate_profile
    create_profile
  end

  def clean_user_courses_cache
    Rails.cache.delete("user/#{id}/courses")
  end

  # touch all chats, user belongs to
  def touch_chats
    # "unless" need to prevent queries if code is wrapped by 'ActiveRecord::Base.no_touching' around
    chats.each(&:touch) unless no_touching?
  end

  class << self
    # message a hash of the token
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
