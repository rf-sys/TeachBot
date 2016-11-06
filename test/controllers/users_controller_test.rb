require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "Activation mail has been sent" do
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
    activation_mail = ActionMailer::Base.deliveries.last

    assert_equal "Account activation", activation_mail.subject
    assert_equal 'test@test.com', activation_mail.to[0]
    assert_match(/Hi/, activation_mail.to_s)
  end

end
