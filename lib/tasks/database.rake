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

  task fill_up_users_with_data: :environment do
    100.times { |i|
      User.create(
          username: "devusername-#{i}",
          email: "devemail-#{i}@mail.ru",
          password: 'password',
          activated: false,
      )
    }
  end
end
