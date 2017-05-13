require 'rails_helper'

RSpec.describe Pagination do

  describe '#call' do
    context 'defaults' do
      subject { Pagination.call({ pagination: nil }) }
      it 'sets page to 1' do
        expect(subject[:page]).to eq 1
      end 
      it 'sets per_page to 100' do
        expect(subject[:per_page]).to eq 100
      end
      it 'numbers 1 to 100' do expect(subject[:numbers]).to eq (1..100).to_a 
      end
    end
    context 'next' do
      subject { Pagination.call({ pagination: 'next', page: '2', per_page: '10' }) }
      it 'sets page to 1' do
        expect(subject[:page]).to eq 2 
      end 
      it 'sets per_page to 10' do
        expect(subject[:per_page]).to eq 10
      end
      it 'sets numbers 11 to 20' do
        expect(subject[:numbers]).to eq (11..20).to_a 
      end
    end
    context 'previous' do
      subject { Pagination.call({ pagination: 'next', page: '4', per_page: '10' }) }
      it 'sets page to 1' do
        expect(subject[:page]).to eq 4 
      end 
      it 'sets per_page to 10' do
        expect(subject[:per_page]).to eq 10
      end
      it 'sets numbers 31 to 40' do
        expect(subject[:numbers]).to eq (31..40).to_a 
      end
    end
    describe 'page param' do
      context 'when it is 0' do
        it 'sets page to 1' do
          expect(
            Pagination.call({ pagination: 'next', page: '0', per_page: '10' })
          ).to eq({ page: 1, per_page: 10, numbers: (1..10).to_a })
        end
      end
      context 'when it is negative' do
        it 'sets page to 1' do
          expect(
            Pagination.call({ pagination: 'next', page: '-1', per_page: '10' })
          ).to eq({ page: 1, per_page: 10, numbers: (1..10).to_a })
        end
      end
      context 'when it isnt an integer' do
        it 'sets page to 1' do
          expect(
            Pagination.call({ pagination: 'next', page: 'helloworld', per_page: '10' })
          ).to eq({ page: 1, per_page: 10, numbers: (1..10).to_a })
        end
       # it 'sets per_page to 100
       # /(\D+)/.match(a).nil? and a.to_i > 0
      end
      #999999999 1000000001 previous next
      #http://192.168.1.45:3000/favourites?page=1000000000&pagination=next&per_page=1000
      #999999999001 **** 999999999001
      #999_999_999_001 **** 999999999001
      #1000000000000 **** buzz
      context 'when it is equal to page max' do
          it 'sets page to 1000000000' do
            expect(
              Pagination.call({ pagination: 'next', page: '1000000000', per_page: '1000' })
            ).to eq({ page: 1000000000, per_page: 1000, numbers: (999999999001..1_000_000_000_000).to_a })
          end
      end
      context 'when it is greater than page max' do
        it 'sets page to 1000000000' do
          expect(
            Pagination.call({ pagination: 'next', page: '1000000001', per_page: '1000' })
          ).to eq({ page: 1000000000, per_page: 1000, numbers: (999999999001..1_000_000_000_000).to_a })
        end
      end
    end
    describe 'per_page param' do
      context 'when it is 0' do
        it 'sets per_page to 100' do
          expect(
            Pagination.call({ pagination: 'next', page: '1', per_page: '0' })
          ).to eq({ page: 1, per_page: 100, numbers: (1..100).to_a })
        end
      end
      context 'when it is negative' do
        it 'sets per_page to 100' do
          expect(
            Pagination.call({ pagination: 'next', page: '1', per_page: '-100' })
          ).to eq({ page: 1, per_page: 100, numbers: (1..100).to_a })
        end
      end
      context 'when it is not integer' do
        it 'sets per_page to 100' do
          expect(
            Pagination.call({ pagination: 'next', page: '1', per_page: 'goodbyemoon' })
          ).to eq({ page: 1, per_page: 100, numbers: (1..100).to_a })
        end
       # it 'sets per_page to 100
       # /(\D+)/.match(a).nil? and a.to_i > 0

      end
      context 'when it is equal to per_page max' do
        it 'sets per_page to 1000' do
          expect(
            Pagination.call({ pagination: 'next', page: '1000000000', per_page: '1000' })
          ).to eq({ page: 1000000000, per_page: 1000, numbers: (999999999001..1_000_000_000_000).to_a })
        end
      end
      context 'when it is greater than per_page max' do
        it 'sets per_page to 1000' do
          expect(
            Pagination.call({ pagination: 'next', page: '1000000000', per_page: '5000' })
          ).to eq({ page: 1000000000, per_page: 1000, numbers: (999999999001..1_000_000_000_000) .to_a })
        end
      end
    end
  end
end
