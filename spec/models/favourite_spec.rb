require 'rails_helper'

RSpec.describe Favourite, :type => :model do
  user = User.create(username: 'jose', password: 'elixir')
  subject { described_class.new(number: 666, user_id: user.id) }

  it 'is not valid without a number' do
    subject.number = nil
    expect(subject).to_not be_valid
  end
  it 'is not valid without a user_id' do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end
end
