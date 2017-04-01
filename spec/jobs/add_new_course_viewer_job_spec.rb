require 'rails_helper'

RSpec.describe AddNewCourseViewerJob, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @course = create(:course)
  end

  subject(:job) { described_class.perform_later('127.0.0.1', @course.id) }

  it 'queues the job' do
    jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
    expect { job }.to change(jobs, :size).by(1)
  end

  it 'job matches the enqueued job' do
    expect { job }.to have_enqueued_job(AddNewCourseViewerJob)
  end

  it 'has appropriate arguments' do
    expect { job }.to have_enqueued_job.with('127.0.0.1', @course.id)
  end

  it 'has appropriate queue name' do
    expect { job }.to have_enqueued_job.on_queue('default')
  end
end
