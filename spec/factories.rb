FactoryGirl.define do
  factory :user, aliases: [:author] do
    username 'TestUser1'
    email 'testuser@gmail.com'
    password 'password'
    activated true
    activation_token User.new_token
  end

  factory :second_user, class: User do
    username 'TestUser2'
    email 'testuser2@gmail.com'
    password 'password'
    activated true
    activation_token User.new_token
  end

  factory :course do
    author
    title 'Test Course Title'
    description 'Test Course Description'
    public true
  end

  factory :post do
    user
    title 'testPost'
    text 'testText'
  end
end