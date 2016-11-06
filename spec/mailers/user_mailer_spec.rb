require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation_mail' do
    before :each do
      @user = User.create(username: 'Oka', email: 'user@test.com', password: 'password')
    end

    let(:mail) { UserMailer.account_activation(@user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Account activation')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
