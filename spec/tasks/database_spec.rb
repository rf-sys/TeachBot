require 'rails_helper'

require 'rake'

describe 'database namespace rake task' do
  before :all do
    Rake.application.rake_require 'tasks/database'
    Rake::Task.define_task(:environment)
  end

  describe 'generate_slug_for_users' do
    let :run_rake_task do
      Rake::Task['database:generate_slug_for_users'].reenable
      Rake.application.invoke_task 'database:generate_slug_for_users'
    end

    it 'should fill up slug for users' do
      user = create(:user)
      slug = user.slug
      user.update_attribute('slug', nil)

      user.reload

      expect(user.slug).to eq(nil)

      run_rake_task

      user.reload

      expect(user.slug).to eq(slug)
    end
  end

  describe 'generate_slug_for_courses' do
    let :run_rake_task do
      Rake::Task['database:generate_slug_for_courses'].reenable
      Rake.application.invoke_task 'database:generate_slug_for_courses'
    end

    it 'should fill up slug for courses' do
      course = create(:course)
      slug = course.slug
      course.update_attribute('slug', nil)

      course.reload

      expect(course.slug).to eq(nil)

      run_rake_task

      course.reload

      expect(course.slug).to eq(slug)
    end
  end

  describe 'generate_slug_for_lessons' do
    let :run_rake_task do
      Rake::Task['database:generate_slug_for_lessons'].reenable
      Rake.application.invoke_task 'database:generate_slug_for_lessons'
    end

    it 'should fill up slug for lessons' do
      lesson = create(:lesson)
      slug = lesson.slug
      lesson.update_attribute('slug', nil)

      lesson.reload

      expect(lesson.slug).to eq(nil)

      run_rake_task

      lesson.reload

      expect(lesson.slug).to eq(slug)
    end
  end
end
