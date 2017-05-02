require 'rails_helper'

RSpec.describe Favourite, :type => :model do
  subject { described_class.new(number: 666) }

  it 'is not valid without a number' do
    expect(subject).to be_valid
  end
end
