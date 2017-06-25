json.extract! @post, :id, :text, :created_at
json.attachments @post.attachments do |attachment|
  json.id attachment.id
  json.template attachment.template
end
