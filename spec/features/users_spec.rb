require 'rails_helper'

describe 'the signin process', type: :feature, js: true do
  describe 'user profile' do
    before(:each) do
      @user = create(:user)
      page.driver.resize(1920, 1080)
    end

    it 'should redirect me with message after I deleted my user' do
      auth_for_capybara(page, @user.id)

      visit user_path(@user)

      click_link('Settings')
      expect(page).to have_selector('#edit_user_form')

      find('#delete_user_btn').click

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('User has been deleted.')
      expect(page).not_to have_content(@user.username)
    end

    it 'I don\'t see things, that can be shown only to profile\'s owner' do
      visit user_path(@user)
      expect(page).not_to have_content('Settings')
      expect(page).not_to have_content('Create course')
      expect(page).not_to have_content('Show form')
    end
  end
end