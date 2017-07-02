require 'application_system_test_case'

# Vue "mini_notice" application
class MiniNoticeVueappTest < ApplicationSystemTestCase
  test 'show and hide notice' do
    visit public_chat_url
    # redirects us to login page as we no auth
    assert_text "Sign in"
    assert_text "You need to login"
    sleep(4)
    assert_no_text "You need to login"
  end
end
