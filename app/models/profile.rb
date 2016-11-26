class Profile < ApplicationRecord
  belongs_to :user, touch: true

=begin
  validates :facebook, format: {
      with: /\A(https?:\/\/)?(www\.)?(facebook.com)\/(.+)\z/,
      message: 'url is invalid. Example: https://www.facebook.com/my_facebook_username_or_id'}, allow_blank: true

  validates :twitter, format: {
      with: /\A(https?:\/\/)?(www\.)?(twitter.com)\/(.+)\z/,
      message: 'url is invalid. Example: https://twitter.com/my_username'}, allow_blank: true
=end

end
