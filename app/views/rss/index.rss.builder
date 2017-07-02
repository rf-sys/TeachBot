xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'TeachBot'
    xml.description 'Education platform'
    xml.link root_url

    @lessons.each do |lesson|
      xml.item do
        xml.title lesson.title
        xml.description lesson.description
        xml.pubDate lesson.created_at.to_s(:rfc822)
        xml.link course_lesson_url(lesson.course, lesson)
        xml.guid course_lesson_url(lesson.course, lesson)
      end
    end
  end
end
