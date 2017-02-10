namespace :database do
  desc "Fill up all empty rows of the 'slug' column in 'users' table"
  task generate_slug_for_users: :environment do
    User.all.each do |user|
      user.update(slug: user.username.parameterize) unless user.slug
    end
  end
  task generate_slug_for_courses: :environment do
    Course.all.each do |course|
      course.update(slug: course.title.parameterize) unless course.slug
    end
  end

  task generate_slug_for_lessons: :environment do
    Lesson.all.each do |lesson|
      lesson.update(slug: lesson.title.parameterize) unless lesson.slug
    end
  end

  task fill_up_users_wtih_data: :environment do
    1000.times { |i|
      User.create(
          username: "devusername-#{i}",
          email: "devemail-#{i}@mail.ru",
          password: 'password',
          activated: false,
      )
    }
  end

  task fill_up_subscribers_count_courses_table: :environment do
    @courses = Course.all

    @courses.each do |course|
      course.update_attribute('subscribers_count', course.subscribers.size)
    end
  end
end
