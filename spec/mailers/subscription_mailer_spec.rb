require 'rails_helper'

RSpec.describe SubscriptionMailer, type: :mailer do

  before(:each) do
    @lesson = create(:lesson)
  end

  let(:mail) { SubscriptionMailer.new_lesson_email(@lesson.course.id, @lesson.id, @lesson.course.author.id) }

  it 'has valid content' do
    expect(mail.subject).to eq('New lesson has been created!')
    expect(mail.to).to eq([@lesson.course.author.email])
    expect(mail.from).to eq(['teachbotmail@gmail.com'])
    expect(mail.body.encoded).to match("Course \"#{@lesson.course.title}\" has published new lesson: \"#{@lesson.title}\"")
  end
end
