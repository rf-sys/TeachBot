require 'rails_helper'

RSpec.describe IncreaseTagsRecommendationJob, type: :job do
  include ActiveJob::TestHelper

  before :each do
    @user = create(:user)
  end

  subject(:job) { described_class.perform_later(%w(tag1 tag2), @user.id) }

  it 'queues the job' do
    jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
    expect { job }.to change(jobs, :size).by(1)
  end

  it 'job matches the enqueued job' do
    expect { job }.to have_enqueued_job(IncreaseTagsRecommendationJob)
  end

  it 'has appropriate arguments' do
    expect { job }.to have_enqueued_job.with(%w(tag1 tag2), @user.id)
  end

  it 'has appropriate queue name' do
    expect { job }.to have_enqueued_job.on_queue('default')
  end

  describe 'behaviour' do
    before :each do
      @redis = Redis.new
      @key = RedisGlobals.user_popular_tags(@user.id)
    end

    it 'add tags to set' do
      assert_equal @redis.zcard(@key), 0

      launch_job %w(tag1 tag2)

      assert_equal @redis.zcard(@key), 2
    end

    it 'increases tag popularity' do
      launch_job %w(tag1 tag2 tag3)

      assert_equal @redis.zcard(@key), 3

      expect(top_tag(@key)).to eq 'tag3'

      2.times { launch_job %w(tag2) }

      expect(top_tag(@key)).to eq 'tag2'

      3.times { launch_job %w(tag1) }

      expect(top_tag(@key)).to eq 'tag1'

    end
  end

  private

  def launch_job(tags)
    described_class.perform_now(tags, @user.id)
  end

  def top_tag(key)
    redis = Redis.new
    redis.zrevrange(key, 0, -1)[0]
  end
end
