FactoryGirl.define do
  factory :user do
    username 'TestUser1'
    email 'testuser@gmail.com'
    password 'password'
    activated true
    activation_token User.new_token
  end
end