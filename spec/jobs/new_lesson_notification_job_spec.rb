require 'rails_helper'

RSpec.describe NewLessonNotificationJob, type: :job do
  include ActiveJob::TestHelper
  before :each do
    @lesson = create(:lesson)
    @course = @lesson.course
  end

  subject(:job_queue) { described_class.perform_later(@course, @lesson) }
  subject(:job_now) { described_class.perform_now(@course, @lesson) }

  it 'queues the job' do
    job_queue
    expect(NewLessonNotificationJob).to have_been_enqueued
  end

  it 'attaches notification to subscribers' do
    @course.author.subscriptions_to_courses << @course
    expect { job_now }.to change(Notification, :count).by(1)
  end
end
