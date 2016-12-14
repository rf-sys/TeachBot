require 'rails_helper'

RSpec.describe CoursesController, :type => :controller do
  before :each do
    @course = create(:course)
    @redis = Redis.new
    @redis.flushall
  end
  describe 'GET #show' do
    it 'changes redis' do
      get :show, params: {id: @course.id}
      expect(response).to be_success
      expect(@redis.get("courses/#{@course.id}/visitors")).to eq('1')
    end
  end
end