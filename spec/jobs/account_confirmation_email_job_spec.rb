require 'rails_helper'

RSpec.describe UserMailer, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @user = User.first_or_create(username: 'Okalia', email: 'rodion2014@inbox.ru', password: 'pass')
  end

  subject(:email) { described_class.account_activation(@user, User.new_token) }

  it 'queues the job' do
    expect { email.deliver_later }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'changes queue' do
    expect(email.deliver_later(queue: 'email').queue_name).to eq('email')
  end

  it 'has appropriate queue name' do
    expect(email.deliver_later.queue_name).to eq('mailers')
  end

  it 'sends valid data' do
    assert_equal [@user.email], email.to
    assert_equal 'Account activation', email.subject
    assert_match(/Hi #{@user.username}/, email.html_part.body.to_s)
  end
end
