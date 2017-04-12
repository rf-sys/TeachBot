require 'rails_helper'

describe 'Courses', type: :feature, js: true do
  context 'courses#index' do
    it 'does not render recommendations block if no auth' do
      visit courses_path

      expect(page).not_to have_selector('#recommendations_block')
    end

    it 'does not render recommendations block if no recommendations' do
      user = create(:user)

      auth_for_capybara(page, user.id)

      visit courses_path

      expect(page).not_to have_selector('#recommendations_block')
    end

    it 'renders recommendations if auth and any present' do
      user = create(:user)

      course = create(:course, author: user)

      course.tags << [Tag.new(name: 'ruby'), Tag.new(name: 'rails')]

      auth_for_capybara(page, user.id)
      add_recommendations(%w(ruby rails), user.id)
      visit courses_path
      expect(page).to have_selector('#recommendations_block')
    end
  end

  private

  def add_recommendations(tags, user_id)
    key ||= RedisGlobals.user_popular_tags(user_id)

    tags.each do |tag|
      Redis.new.zincrby(key, 1, tag)
    end

    GenerateRecommendedCoursesJob.perform_now(user_id)
  end
end