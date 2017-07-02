require 'rails_helper'

RSpec.describe AddNewCourseViewerJob, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @course = create(:course)
    redis = Redis.new
    redis.del("users/0.0.0.0/courses/#{@course.id}/visited_at")
  end

  subject(:job) { described_class.perform_later(@course.id) }
  subject(:job_now) { described_class.perform_now(@course.id) }

  it 'queues the job' do
    jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
    expect { job }.to change(jobs, :size).by(1)
  end

  it 'job matches the enqueued job' do
    expect { job }.to have_enqueued_job(AddNewCourseViewerJob)
  end

  it 'has appropriate arguments' do
    expect { job }.to have_enqueued_job.with(@course.id)
  end

  it 'has appropriate queue name' do
    expect { job }.to have_enqueued_job.on_queue('default')
  end

  it 'add views when executed' do
    assert @course.views, 0
    job_now
    assert @course.views, 1
  end
end
