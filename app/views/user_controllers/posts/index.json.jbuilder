json.posts do
  json.array! @posts do |post|
    json.extract! post, :id, :text, :created_at
    json.attachments post.attachments do |attachment|
      json.id attachment.id
      json.template attachment.template
    end
  end
end

json.current_page @posts.current_page
json.total_pages @posts.total_pages
