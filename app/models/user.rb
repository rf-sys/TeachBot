class User < ApplicationRecord
  require 'validators/EmailValidator'
  require 'sendgrid-ruby'
  include SendGrid

  attr_accessor :remember_token, :activation_token

  validates :username, :email, presence: true, uniqueness: true
  validates :username, length: {maximum: 50}

  validates :email, email: true, length: {maximum: 255}

  before_save :downcase_email
  before_create :create_activation_digest
  before_destroy :delete_avatar

  has_secure_password


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
    UserMailer.account_activation(self).deliver_now
  end


  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
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
