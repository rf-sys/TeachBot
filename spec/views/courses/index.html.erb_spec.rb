require 'rails_helper'

RSpec.describe 'courses/index.html.erb', type: :view do
  before :each do
    assign(:courses, Course.public_and_published.page(params[:page]).per(6))
    assign(:popular_tags, [])
    assign(:recommendations, [])
  end

  it 'renders public and published courses' do
    create(:course)
    render
    expect(view).to render_template(partial: '_course', count: 1)
  end

  it 'no renders unpublished or private courses' do
    create(:private_course,
           title: 'First Private Title', description: 'First Private Desc')

    create(:unpublished_course, author: create(:second_user),
           title: 'First Unpublished Title', description: 'First Unpublished Desc')
    render
    expect(view).to render_template(partial: '_course', count: 0)
  end

  it 'renders popular_tags and recommendations partials' do
    assign(:popular_tags, %w(tag1 tag2))
    assign(:recommendations, [create(:course)])
    render
    expect(view).to render_template(partial: '_popular_tags', count: 1)
    expect(view).to render_template(partial: '_recommendations', count: 1)
  end
end
