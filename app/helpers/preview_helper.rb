module PreviewHelper
  def open_a_tag(url)
    "<a href='#{url}' class='attachment_a_tag' target='_blank'>"
  end

  def close_a_tag
    '</a>'
  end
end
