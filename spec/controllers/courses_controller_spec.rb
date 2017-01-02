require 'rails_helper'

RSpec.describe CoursesController, :type => :controller do
  include ActiveJob::TestHelper
  before :each do
    @course = create(:course)
    @redis = Redis.new
    @redis.flushall
  end
  describe 'GET #show' do
    it 'changes redis' do
      expect {
        get :show, params: {id: @course.id}

      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end
end