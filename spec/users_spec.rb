require "rails_helper"

RSpec.describe User, :type => :model do
  it "orders by last name" do
    lindeman = User.create!(username: "Andy", email: "rodion2104@inbox.ru", password: "hasher")
    chelimsky = User.create!(username: "Meyvit", email: "rodion21004@inbox.ru", password: "dehasher")

    expect(User.order(:username)).to eq([lindeman, chelimsky])
  end
end