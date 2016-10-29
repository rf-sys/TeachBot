require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "signup mail has been sent" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post users_path, params: {
          user: {
              username: 'Okalia',
              email: 'test@test.com',
              password: 'password',
              password_digest: 'password'
          }
      }
    end
    signup_mail = ActionMailer::Base.deliveries.last

    puts signup_mail
    assert_equal "Thank you for signup", signup_mail.subject
    assert_equal 'test@test.com', signup_mail.to[0]
    assert_match(/You have successfully signed up to example.com/, signup_mail.to_s)
  end

end
