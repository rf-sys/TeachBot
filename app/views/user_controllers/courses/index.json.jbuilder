json.courses @courses do |course|
  json.extract! course, :id, :title, :description, :created_at, :slug, :public
end
json.current_page params[:page].to_i
json.total_pages @courses.total_pages
