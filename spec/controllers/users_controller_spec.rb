require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  include ActiveJob::TestHelper
  it 'responds successfully if correct data' do
    expect {
      post :message, params: {
          user: {
              username: 'Okalia',
              email: 'okalia@example.com',
              password: 'password',
              password_confirmation: 'password'
          }
      }
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    expect(response).to have_http_status(302) # indicate redirect status code
    expect(response).to redirect_to(root_path)
  end

  it 'responds as error if incorrect data' do
    expect {
      post :message, params: {
          user: {
              username: 'Okalia',
              email: '',
              password: 'password',
              password_confirmation: 'password'
          }
      }
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(0)
    expect(response).to have_http_status(422)
  end
end