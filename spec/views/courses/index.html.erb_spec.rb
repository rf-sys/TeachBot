require 'rails_helper'

RSpec.describe 'courses/index.html.erb', type: :view do
  before :each do
    assign(:courses, Course.public_and_published.page(params[:page]).per(6))
  end

  it 'renders public and published courses' do
    create(:course)
    render
    expect(view).to render_template(:partial => '_course', :count => 1)
  end

  it 'no renders unpublished or private courses' do
    create(:private_course,
           title: 'First Private Title', description: 'First Private Desc')

    create(:unpublished_course, author: create(:second_user),
           title: 'First Unpublished Title', description: 'First Unpublished Desc')
    render
    expect(view).to render_template(:partial => '_course', :count => 0)
  end
end
