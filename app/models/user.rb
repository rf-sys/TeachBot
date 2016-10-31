class User < ApplicationRecord
  require 'validators/EmailValidator'

  validates :username, :email, presence: true, uniqueness: true

  validates :email, email: true

  before_destroy :delete_avatar

  has_secure_password


  def delete_avatar
    if File.file?(Rails.root.join('public', 'assets/images/avatars', "#{self.id}.jpg"))
      FileUtils.rm(Rails.root.join('public', 'assets/images/avatars', "#{self.id}.jpg"))
    end
  end

end
