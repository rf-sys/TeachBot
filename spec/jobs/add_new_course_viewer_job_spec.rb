require 'rails_helper'

RSpec.describe AddNewCourseViewerJob, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @course = create(:course)
  end

  subject(:job) { described_class.perform_later('127.0.0.1', @course.id) }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

end
