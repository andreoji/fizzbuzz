require 'rails_helper'

RSpec.describe FavouritesLogic do
  describe '#call' do
    describe 'when new favourites only' do
      let(:saved_favourites) { [1, 2, 999, 1000] } 
      let(:marked_as_favourites) { [1, 2, 9, 10] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { FavouritesLogic.call(marked_as_favourites, current_page_numbers, saved_favourites) }
      it 'calculates new favourites 9 and 10' do
        expect(subject[:new_favourites]).to eq [9, 10] 
      end
      it 'calculates deleted favourites as empty' do
        expect(subject[:deleted_favourites]).to eq [] 
      end
    end
    describe 'when new favourites are out of page bounds' do
      let(:saved_favourites) { [1, 2, 999, 1000] } 
      let(:marked_as_favourites) { [1, 2, 9, 10, 11, 12] } 
      let(:current_page_numbers) { (1..10).to_a } 
      it 'exception to be raised' do
        expect{
          FavouritesLogic.call(marked_as_favourites, current_page_numbers, saved_favourites)
        }.to raise_error("numbers must be within page limits")
      end
    end
    describe 'when deleted and new favourites' do
      let(:saved_favourites) { [1, 2, 99, 100] } 
      let(:marked_as_favourites) { [5, 6] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { FavouritesLogic.call(marked_as_favourites, current_page_numbers, saved_favourites) }
      it 'calculates new favourites 5 and 6' do
        expect(subject[:new_favourites]).to eq [5, 6] 
      end
      it 'calculates deleted favourites 1 and 2' do
        expect(subject[:deleted_favourites]).to eq [1, 2] 
      end
    end
    describe 'when all displayed favourites deleted' do
      let(:saved_favourites) { (1..10).to_a + [99, 100] } 
      let(:marked_as_favourites) { [] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { FavouritesLogic.call(marked_as_favourites, current_page_numbers, saved_favourites) }
      it 'calculates new favourites as empty' do
        expect(subject[:new_favourites]).to eq [] 
      end
      it 'calculates deleted favourites are all displayed favourites' do
        expect(subject[:deleted_favourites]).to eq current_page_numbers 
      end
    end
    describe 'when there are no marked numbers and no favourites displayed' do
      let(:saved_favourites) { [99, 100] } 
      let(:marked_as_favourites) { [] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { FavouritesLogic.call(marked_as_favourites, current_page_numbers, saved_favourites) }
      it 'calculates new favourites as empty' do
        expect(subject[:new_favourites]).to eq [] 
      end
      it 'calculates deleted favourites are empty' do
        expect(subject[:deleted_favourites]).to eq [] 
      end
    end
    describe 'when there are no marked numbers and no saved favourites at all' do
      let(:saved_favourites) { [] } 
      let(:marked_as_favourites) { [] } 
      let(:current_page_numbers) { (1..10).to_a } 
      subject { FavouritesLogic.call(marked_as_favourites, current_page_numbers, saved_favourites) }
      it 'calculates new favourites as empty' do
        expect(subject[:new_favourites]).to eq [] 
      end
      it 'calculates deleted favourites are empty' do
        expect(subject[:deleted_favourites]).to eq [] 
      end
    end
  end
end
