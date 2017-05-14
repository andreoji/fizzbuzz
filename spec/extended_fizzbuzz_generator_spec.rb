require 'rails_helper'

RSpec.describe ExtendedFizzbuzzGenerator do
  describe '#numbers' do
    describe 'when new favourites only' do
      let!(:jose) { create(:user, username: 'jose', password_digest: 'elixir') }
      let!(:jose_favourite_1) { create(:favourite, number: 1, user_id: jose.id) }
      let!(:jose_favourite_2) { create(:favourite, number: 2, user_id: jose.id) }
      let!(:jose_favourite_999) { create(:favourite, number: 999, user_id: jose.id) }
      let!(:jose_favourite_1000) { create(:favourite, number: 1000, user_id: jose.id) }
      let(:saved_favourites) { [1, 2, 999, 1000] } 
      let(:marked_as_favourites) { [1, 2, 9, 10] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { ExtendedFizzbuzzGenerator.new({ current_user_id: jose.id,
                                                params: { marked_as_favourites: marked_as_favourites },
                                                favourites:  saved_favourites} ) }
      it 'creates favourites 9 and 10' do
        subject.numbers(1, 10)
        expect(Favourite.where("user_id = ?", jose.id).order(:number).pluck(:number)).to eq [1, 2, 9, 10, 999, 1000]
      end
    end
    describe 'when deleted and new favourites' do
      let!(:jose) { create(:user, username: 'jose', password_digest: 'elixir') }
      let!(:jose_favourite_1) { create(:favourite, number: 1, user_id: jose.id) }
      let!(:jose_favourite_2) { create(:favourite, number: 2, user_id: jose.id) }
      let!(:jose_favourite_99) { create(:favourite, number: 99, user_id: jose.id) }
      let!(:jose_favourite_100) { create(:favourite, number: 100, user_id: jose.id) }
      let(:saved_favourites) { [1, 2, 99, 100] } 
      let(:marked_as_favourites) { [5, 6] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { ExtendedFizzbuzzGenerator.new({ current_user_id: jose.id,
                                                params: { marked_as_favourites: marked_as_favourites },
                                                favourites:  saved_favourites} ) }
      it 'creates favourites 5 and 6, deletes favourites 1 and 2' do
        subject.numbers(1, 10)
        expect(Favourite.where("user_id = ?", jose.id).order(:number).pluck(:number)).to eq [5, 6, 99, 100]
      end
    end
    describe 'when all displayed favourites deleted' do
      let!(:jose) { create(:user, username: 'jose', password_digest: 'elixir') }
      let!(:jose_favourite_1_to_10) { (1..10).map { |n| create(:favourite, number: n, user_id: jose.id) } }
      let!(:jose_favourite_99) { create(:favourite, number: 99, user_id: jose.id) }
      let!(:jose_favourite_100) { create(:favourite, number: 100, user_id: jose.id) }
      let(:saved_favourites) { (1..10).to_a + [99, 100] } 
      let(:marked_as_favourites) { [] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { ExtendedFizzbuzzGenerator.new({ current_user_id: jose.id,
                                                params: { marked_as_favourites: marked_as_favourites },
                                                favourites:  saved_favourites} ) }
      it 'doesnt delete non displayed favourites' do
        subject.numbers(1, 10)
        expect(Favourite.where("user_id = ?", jose.id).order(:number).pluck(:number)).to eq [99, 100]
      end
    end
    describe 'when there are no marked numbers and no saved favourites at all' do
      let!(:jose) { create(:user, username: 'jose', password_digest: 'elixir') }
      let(:saved_favourites) { [] } 
      let(:marked_as_favourites) { [] } 
      let(:current_page_numbers) { (1..10).to_a } 
      let(:first_ten_fizzbuzzes_no_favourites) {
        [{ number: 1, value: 1, fave: false },
         { number: 2, value: 2, fave: false },
         { number: 3, value: 'fizz', fave: false },
         { number: 4, value: 4, fave: false },
         { number: 5, value: 'buzz', fave: false },
         { number: 6, value: 'fizz', fave: false },
         { number: 7, value: 7, fave: false },
         { number: 8, value: 8, fave: false },
         { number: 9, value: 'fizz', fave: false },
         { number: 10, value: 'buzz', fave: false }]
      }
      subject { ExtendedFizzbuzzGenerator.new({ current_user_id: jose.id,
                                                params: { marked_as_favourites: marked_as_favourites },
                                                favourites:  saved_favourites} ) }
      it 'returns the first ten fizzbuzz numbers as no favourites' do
        expect(subject.numbers(1, 10)).to eq first_ten_fizzbuzzes_no_favourites
      end
    end
  end
end
