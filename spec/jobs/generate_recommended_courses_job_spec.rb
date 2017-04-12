require 'rails_helper'

RSpec.describe GenerateRecommendedCoursesJob, type: :job do
  include ActiveJob::TestHelper

  before :each do
    @user = create(:user)
  end

  subject(:job) { described_class.perform_later(@user.id) }

  it 'queues the job' do
    jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
    expect { job }.to change(jobs, :size).by(1)
  end

  it 'job matches the enqueued job' do
    expect { job }.to have_enqueued_job(GenerateRecommendedCoursesJob)
  end

  it 'has appropriate arguments' do
    expect { job }.to have_enqueued_job.with(@user.id)
  end

  it 'has appropriate queue name' do
    expect { job }.to have_enqueued_job.on_queue('default')
  end

  describe 'behaviour' do
    before :each do
      @redis = Redis.new
      @user_recommendations = RedisGlobals.user_recommendations @user.id
    end

    it 'recommends courses with the greatest number of tag matches' do

      # all tags are appropriate
      appropriate_course = create_course %w(ruby js)

      # only one tag is appropriate
      partially_appropriate_course = create_course ['ruby']

      # no appropriate tags
      inappropriate_course = create_course %w(tag1 tag2)

      inappropriate_course.tags << [Tag.new(name: 'tag1'), Tag.new(name: 'tag2')]

      add_tags_to_recommended_tags(appropriate_course.tags.pluck(:name))

      generate_recommendation

      recommended_courses = @redis.zrange(@user_recommendations, 0, -1)

      expect(recommended_courses[0].to_i).to eq appropriate_course.id
      expect(recommended_courses[1].to_i).to eq partially_appropriate_course.id

      expect(@redis.zcard(@user_recommendations)).to eq 2
    end
  end

  private

  def create_course(tags_collection)
    course = create(:course, author: @user)

    tags = []

    tags_collection.each { |tag| tags << Tag.new(name: tag) }

    course.tags << tags
    course
  end

  def add_tags_to_recommended_tags(tags)
    IncreaseTagsRecommendationJob.perform_now(tags, @user.id)
  end

  def generate_recommendation
    described_class.perform_now(@user.id)
  end
end
