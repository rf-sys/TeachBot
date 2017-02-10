require 'rails_helper'

RSpec.describe 'routing to Sidekiq UI', :type => :routing do
  it 'denies access for no admin' do
    expect(:get => '/sidekiq').not_to be_routable
  end
end