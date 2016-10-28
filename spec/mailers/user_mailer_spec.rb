require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'instructions' do
    before :each do
      @user = User.create(username: 'Oka', email: 'user@test.com', password: 'password')
    end

    let(:mail) { UserMailer.signup_mail(@user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Thank you for signup')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
