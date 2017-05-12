require 'rails_helper'

RSpec.describe Fizzbuzzer do

  describe '#call' do
    let(:fizzbuzz_one_to_fifteen) {[{number: 1, value: 1}, {number: 2, value: 2}, {number: 3, value: 'fizz'},
                                    {number: 4, value: 4}, {number: 5, value: 'buzz'}, {number: 6, value: 'fizz'},
                                    {number: 7, value: 7}, {number: 8, value: 8}, {number: 9, value: 'fizz'},
                                    {number: 10, value: 'buzz'}, {number: 11, value: 11}, {number: 12, value: 'fizz'},
                                    {number: 13, value: 13}, {number: 14, value: 14}, {number: 15, value: 'fizzbuzz'}]}

    it '1 to 15' do
      expect(Fizzbuzzer.call((1..15).to_a)).to eq fizzbuzz_one_to_fifteen
    end  
  end
end
