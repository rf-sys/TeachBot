require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  include ActiveJob::TestHelper
  before :each do
    @user = create(:user)
  end
  describe 'activation_email' do
    let(:mail) { described_class.account_activation(@user, @user.activation_token) }

    it 'sends through http if development env' do
      Rails.env = 'development'
      expect(mail.body.encoded).to match('http')
    end

    it 'sends through https if production env' do
      Rails.env = 'production'
      expect(mail.body.encoded).to match('https')
    end

    it 'sends activation email to the user' do
      expect do
        @user.send_activation_email
      end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'sends activation email to the user again' do
      expect do
        @user.resend_activation_email
      end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end
end