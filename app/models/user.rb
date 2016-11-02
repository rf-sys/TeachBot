class User < ApplicationRecord
  require 'validators/EmailValidator'

  attr_accessor :remember_token

  validates :username, :email, presence: true, uniqueness: true
  validates :username, length: {maximum: 50}

  validates :email, email: true, length: {maximum: 255}

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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


  private

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
