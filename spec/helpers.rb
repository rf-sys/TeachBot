# Set session_id that equals user's id
# @param [User] user
def auth_as(user)
  session[:user_id] = user.id
end

# set auth user for capybara tests
# @param [Capybara::DSL] page
# @param [Integer] id
def auth_for_capybara(page, id)
  page.set_rack_session(user_id: id)
end

def set_json_request
  request.env['HTTP_ACCEPT'] = 'application/json'
end

def set_js_request
  request.env['HTTP_ACCEPT'] = ' application/javascript'
end

def omniauth_facebook_mock_user
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
    provider:    'facebook',
    uid:         '1235456',
    info:        {
      name:  'mockuser_facebook',
      email: 'mockuser@gmail.com',
      image: 'mock_user_thumbnail_url'
    },
    credentials: {
      token:  'mock_token',
      secret: 'mock_secret'
    }
  )
end

def omniauth_github_mock_user
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider:    'github',
    uid:         '1235456',
    info:        {
      name:  'mockuser_github',
      email: 'mockuser@gmail.com',
      image: 'mock_user_thumbnail_url'
    },
    credentials: {
      token:  'mock_token',
      secret: 'mock_secret'
    }
  )
end

def clean_redis
  redis = RedisSingleton.instance
  keys = redis.keys('*' + RedisGlobals.test_env_suffix)
  redis.del(keys) if keys.any?
end
