json.courses do
  json.array! @courses do |course|
    json.extract! course, :id, :title, :description, :updated_at, :slug, :poster, :tags
  end
end

json.lessons do
  json.array! @lessons do |lesson|
    json.extract! lesson, :id, :title, :description, :updated_at, :slug
    json.course do
      json.extract! lesson.course, :title, :slug
    end
  end
end

json.users do
  json.array! @users do |user|
    json.extract! user, :id, :username, :avatar, :slug
  end
end
