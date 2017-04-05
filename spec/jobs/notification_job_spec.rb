require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @recipient = create(:user)
    @notification = create(:notification, user: @recipient)
  end

  subject(:job) { described_class.perform_later(@recipient.id, @notification.id) }

  it 'queues the job' do
    jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
    expect { job }.to change(jobs, :size).by(1)
  end

  it 'job matches the enqueued job' do
    expect { job }.to have_enqueued_job(NotificationJob)
  end

  it 'has appropriate arguments' do
    expect { job }.to have_enqueued_job.with(@recipient.id, @notification.id)
  end

  it 'has appropriate queue name' do
    expect { job }.to have_enqueued_job.on_queue('notifications')
  end
end
