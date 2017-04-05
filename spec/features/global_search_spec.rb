require 'rails_helper'

describe 'global search', type: :feature, js: true do
  it 'shows panel after load page' do
    visit root_path

    expect(page).not_to have_selector('nav #global_search_panel')
    expect(page).not_to have_selector('nav #global_search_input')

    find('#navbar_toggler').click

    expect(page).to have_selector('nav #global_search_panel')
    expect(page).to have_selector('nav #global_search_input')
  end

  it 'shows found users result' do
    user = create(:user)
    user.reindex(refresh: true)

    visit root_path
    find('#navbar_toggler').click

    element = find('input#global_search_input')

    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys(user.username)

    sleep(3)

    expect(page).to have_content('Users')
    expect(page).to have_content(user.username)
    expect(page).to have_selector("a[name='gs_user_#{user.friendly_id}_link']")
  end

  it 'shows found lessons result' do
    lesson = create(:lesson)
    lesson.reindex(refresh: true)

    visit root_path
    find('#navbar_toggler').click

    element = find('input#global_search_input')

    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys(lesson.title)

    sleep(3)

    expect(page).to have_content('Lessons')
    expect(page).to have_content(lesson.title)
    expect(page).to have_selector("a[name='gs_lesson_#{lesson.friendly_id}_link']")
  end

  it 'shows found courses result' do
    course = create(:course)
    course.reindex(refresh: true)

    visit root_path
    find('#navbar_toggler').click

    element = find('input#global_search_input')

    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys(course.title)

    sleep(3)

    expect(page).to have_content('Courses')
    expect(page).to have_content(course.title)
    expect(page).to have_selector("a[name='gs_course_#{course.friendly_id}_link']")
  end

  it "shows 'No results' result" do
    visit root_path
    find('#navbar_toggler').click

    element = find('input#global_search_input')

    # to exec 'typing by user' event (necessary for React listeners)
    element.send_keys('random string')

    sleep(3)

    expect(page).to have_content('No results')
  end
end