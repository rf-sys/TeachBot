require 'rails_helper'

describe 'global search', type: :feature, js: true do
  it 'shows panel after load page' do
    visit root_path

    header_search_panel_app = 'nav #header_search_panel_app'
    expect(page).not_to have_selector(header_search_panel_app)
    expect(page).not_to have_selector(header_search_panel_app)

    find('#navbar_toggler').click

    expect(page).to have_selector(header_search_panel_app)
    expect(page).to have_selector(header_search_panel_app)
  end

  it 'shows found users result' do
    user = create(:user)
    user.reindex(refresh: true)

    visit root_path
    find('#navbar_toggler').click
    sleep(1)

    element = find('input#header_search_input')
    element.send_keys(user.username)

    # to exec 'typing by user' event (necessary for React listeners)
    # element.send_keys(user.username)

    sleep(3)

    expect(page).to have_content('Users')
    expect(page).to have_content(user.username)
    expect(page).to have_selector("a[href='#{user_path(user)}']")
  end

  it 'shows found lessons result' do
    lesson = create(:lesson)
    lesson.reindex(refresh: true)

    visit root_path
    find('#navbar_toggler').click

    element = find('input#header_search_input')

    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys(lesson.title)

    sleep(3)

    expect(page).to have_content('Lessons')
    expect(page).to have_content(lesson.title)
    expect(page).to have_selector("a[href='#{course_lesson_path(lesson.course, lesson)}']")
  end

  it 'shows found courses result' do
    course = create(:course)
    course.reindex(refresh: true)

    visit root_path
    find('#navbar_toggler').click

    element = find('input#header_search_input')

    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys(course.title)

    sleep(3)

    expect(page).to have_content('Courses')
    expect(page).to have_content(course.title)
    expect(page).to have_selector("a[href='#{course_path(course)}']")
  end

  it "shows 'Not found' result" do
    visit root_path

    find('#navbar_toggler').click

    element = find('input#header_search_input')
    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys('random string')

    sleep(5)

    expect(page).to have_content('Not found', count: 3)
  end
end