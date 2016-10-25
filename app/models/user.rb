class User < ApplicationRecord
  require 'validators/EmailValidator'

  validates :username, :email, presence: true, uniqueness: true

  validates :email, email: true

  has_secure_password

end
