require 'rails_helper'

describe 'HeaderSearch', type: :feature, js: true do
  before :each do
    page.driver.resize(1920, 1080)
  end

  it 'shows search panel' do
    visit root_path
    sleep(2)
    expect(page).to have_selector search_panel_selector
  end

  it 'has search input' do
    visit root_path
    sleep(2)
    expect(page).to have_selector search_input_selector
  end

  it 'renders results' do
    lesson = create(:lesson)
    Lesson.reindex

    visit root_path
    sleep(2)
    expect(page).not_to have_selector results_list_selector

    search_input.send_keys(lesson.title)

    sleep(2)
    expect(page).to have_selector results_list_selector

    expect(results_list['innerHTML']).to have_content(lesson.title)
    expect(results_list['innerHTML']).to have_content(lesson.description)
    expect(results_list['innerHTML']).to have_content(lesson.course.title)
    expect(results_list['innerHTML']).to have_selector("a[href='#{course_lesson_path(lesson.course, lesson)}']")
  end

  it 'renders courses' do
    course = create(:course)
    Course.reindex

    visit root_path
    sleep(2)
    expect(page).not_to have_selector results_list_selector

    search_input.send_keys(course.title)

    sleep(2)
    expect(page).to have_selector results_list_selector

    expect(results_list['innerHTML']).to have_content(course.title)
    expect(results_list['innerHTML']).to have_content(course.description)
    expect(results_list['innerHTML']).to have_selector("a[href='#{course_path(course)}']")
  end

  it 'renders users' do
    user = create(:user)
    User.reindex

    visit root_path
    sleep(2)
    expect(page).not_to have_selector results_list_selector

    search_input.send_keys(user.username)

    sleep(2)
    expect(page).to have_selector results_list_selector

    expect(results_list['innerHTML']).to have_content(user.username)
    expect(results_list['innerHTML']).to have_selector("a[href='#{user_path(user)}']")
  end

  it 'renders "not found" if nothing is found' do
    visit root_path
    sleep(2)
    expect(page).not_to have_selector results_list_selector
    expect(page).not_to have_selector results_not_found_selector

    search_input.send_keys('random string')

    sleep(2)
    expect(page).not_to have_selector results_list_selector
    expect(page).to have_selector results_not_found_selector
    expect(results_not_found['innerHTML']).to have_content('Not found')
  end

  private

  def search_panel_selector
    '#header_search_app_search_panel'
  end

  def search_input_selector
    '#header_search_app_search_input'
  end

  def results_list_selector
    '#header_search_app_results_list'
  end

  def results_not_found_selector
    '#header_search_app_not_found'
  end

  def search_input
    find('#header_search_app_search_input')
  end

  def results_list
    find(results_list_selector)
  end

  def results_not_found
    find(results_not_found_selector)
  end
end
