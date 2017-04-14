FactoryGirl.define do
  factory :tag do
    name "MyString"
  end
  factory :subscription do
    user nil
    subscribeable ""
  end

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
    factory :teacher do
      after(:create) { |user| user.add_role(:teacher) }
    end
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
    association :author, factory: :teacher
    title 'Test Course Title'
    description 'Test Course Description'
    public true
    published true

    factory :private_course do
      public false
    end
    factory :unpublished_course do
      published false
    end
  end

  factory :lesson do
    course
    title 'Test Lesson Title'
    description 'Test Lesson Description'
    content 'Test Lesson Content'
  end

  factory :post do
    user
    title 'testPost'
    text 'testText'
  end
end