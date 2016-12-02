class User < ApplicationRecord
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

  has_many :courses, foreign_key: 'author_id'
  has_and_belongs_to_many :subscriptions, class_name: 'Course'

  scope :select_profile_attr, -> { select(:id, :username, :email, :avatar, :updated_at) }
  scope :find_with_profile, -> (id) { includes(:profile).find(id) }

  attr_accessor :remember_token, :activation_token
  accepts_nested_attributes_for :profile, reject_if: :all_blank

  validates :username, :email, presence: true, uniqueness: true
  validates :username, length: {maximum: 50}
  validates :email, email: true, length: {maximum: 255}
  validates :password, length: (6..32), confirmation: true, if: :setting_password?

  before_save :downcase_email
  before_create :create_activation_digest

  before_destroy :delete_avatar, :cache_cleaner, :clean_user_courses_cache
  after_update_commit :cache_cleaner, :clean_user_courses_cache
  after_create :generate_profile


  # delete avatar before delete user
  def delete_avatar
    if File.file?(Rails.root.join('public', 'assets/images/avatars', "#{self.id}.jpg"))
      FileUtils.rm(Rails.root.join('public', 'assets/images/avatars', "#{self.id}.jpg"))
    end
  end

  # generate and store token to the database
  def remember
    self.remember_token = User.new_token # create new string which is like a token
    update_attribute(:remember_digest, User.digest(remember_token)) # save a hash of the token above in the DB
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self, self.activation_token).deliver_later
  end


  private

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
    self.create_profile
  end

  def clean_user_courses_cache
    Rails.cache.delete("user/#{self.id}/courses")
  end


  class << self
    # create a hash of the token
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
