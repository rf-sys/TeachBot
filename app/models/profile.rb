class Profile < ApplicationRecord
  belongs_to :user, touch: true

  validates :website, format: {
      with: /\Ahttps?:\/\/[^\n]+\z/i
  }, allow_blank: true, length: { maximum: 75 }

  validates :facebook, length: { maximum: 40 }
  validates :twitter, length: { maximum: 40 }
  validates :about, length: { maximum: 500 }
  validates :location, length: { maximum: 100 }

=begin
  validates :facebook, format: {
      with: /\A(https?:\/\/)?(www\.)?(facebook.com)\/(.+)\z/,
      message: 'url is invalid. Example: https://www.facebook.com/my_facebook_username_or_id'}, allow_blank: true

  validates :twitter, format: {
      with: /\A(https?:\/\/)?(www\.)?(twitter.com)\/(.+)\z/,
      message: 'url is invalid. Example: https://twitter.com/my_username'}, allow_blank: true
=end

end
