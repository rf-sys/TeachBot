require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  before :each do
    @request.host = 'localhost:3000'
  end
  describe 'POST #create' do
    it 'valid response and flash message' do
      post :create, { :params => { user: {username: 'Okalia', email: 'rodion2014@inbox.ru', password: 'password'} } }

      expect(response).to redirect_to('/')

      expect(flash[:super_info_notice]).to match('Please check your email (rodion2014@inbox.ru) to activate your account. Email must come during several minutes.')
    end

  end
end