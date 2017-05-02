require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "Validations" do
    subject {
      described_class.new(username: 'jose', password: 'elixir')
    }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a username" do
      subject.username = nil
      expect(subject).to_not be_valid
    end
  end
end
