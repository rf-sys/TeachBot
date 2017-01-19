FactoryGirl.define do
  factory :notification do
    user
    title 'TestNotificationTitle'
    text 'TestNotificationText'
    link 'TestNotificationLink'
    readed false
  end

  factory :chat do
    association :initiator, factory: :user
    association :recipient, factory: :second_user
  end

  factory :message do
    text 'TestMessage'
    factory :message_with_associations do
      chat
      user { chat.initiator }
    end
  end

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

  factory :third_user, class: User do
    username 'TestUser3'
    email 'testuser3@gmail.com'
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

  factory :lesson do
    course
    title 'Test Lesson Title'
    description 'Test Lesson Description'
  end

  factory :post do
    user
    title 'testPost'
    text 'testText'
  end
end