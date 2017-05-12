require 'rails_helper'

RSpec.describe Fizzbuzzer do

  describe '#call' do
    let(:favourites) {[1, 5, 13, 15]}
    let(:fizzbuzz_one_to_fifteen) {[{number: 1, value: 1, fave: true}, {number: 2, value: 2, fave: false},
                                    {number: 3, value: 'fizz', fave: false}, {number: 4, value: 4, fave: false},
                                    {number: 5, value: 'buzz', fave: true}, {number: 6, value: 'fizz', fave: false},
                                    {number: 7, value: 7, fave: false}, {number: 8, value: 8, fave: false},
                                    {number: 9, value: 'fizz', fave: false}, {number: 10, value: 'buzz', fave: false},
                                    {number: 11, value: 11, fave: false}, {number: 12, value: 'fizz', fave: false},
                                    {number: 13, value: 13, fave: true}, {number: 14, value: 14, fave: false},
                                    {number: 15, value: 'fizzbuzz', fave: true}]}

    it '1 to 15' do
      expect(Fizzbuzzer.call((1..15).to_a, favourites)).to eq fizzbuzz_one_to_fifteen
    end  
  end
end
