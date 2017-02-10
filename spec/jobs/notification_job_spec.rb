require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @recipient = create(:user)
    @notification = create(:notification, user: @recipient)
  end

  subject(:job) { described_class.perform_later(@recipient, @notification) }

  it 'adds to queue' do
    job
    expect(NotificationJob).to have_been_enqueued
  end
end
