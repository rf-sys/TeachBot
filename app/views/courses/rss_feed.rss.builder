xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title 'TeachBot'
    xml.description 'Education platform'
    xml.link courses_url

    @courses.each { |course|
      xml.item do
        xml.title course.title
        xml.description course.description
        xml.pubDate course.created_at.to_s(:rfc822)
        xml.link course_url(course)
        xml.guid course_url(course)
      end
    }
  end
end