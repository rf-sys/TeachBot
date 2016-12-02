require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  before :each do
    User.create(username: 'Okalia', email: 'okalia@example.com', password: 'password', activated: true)
  end

  it 'responds successfully if correct data' do
    post :create, params: {
        session: {
            email: 'okalia@example.com',
            password: 'password'
        }
    }

    expect(response).to have_http_status(302) # indicate redirect status code
  end

  it 'responds error status if user not found' do
    post :create, params: {
        session: {
            email: 'invalid@example.com',
            password: 'invalid'
        }
    }

    expect(response).to have_http_status(404)
  end

  it 'calls throttle reaction' do
    5.times do
      post :create, params: {
          session: {
              email: 'invalid@example.com',
              password: 'invalid'
          }
      }
    end
    expect(response).to have_http_status(403)
  end
end