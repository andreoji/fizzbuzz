require 'rails_helper'

RSpec.describe FavouritesController, :type => :controller do

  describe '#index' do
    let!(:jose) { create(:user, username: 'jose', password_digest: 'elixir') }
    let!(:chris) { create(:user, username: 'chris', password_digest: 'phoenix') }
    let!(:jose_favourite) { create(:favourite, number: 1, user_id: jose.id) }
    let!(:jose_other_favourite) { create(:favourite, number: 2, user_id: jose.id) }
    let!(:chris_favourite) { create(:favourite, number: 3, user_id: chris.id) }

    before(:each){
      get :index, session: {user_id: jose.id}
    }
    it 'assigns the currently logged in user\'s favourites' do
      assigned_fizzbuzz_numbers = assigns(:fizzbuzz_numbers)
      expect(assigned_fizzbuzz_numbers.size).to eq 100
      expect(assigned_fizzbuzz_numbers[0]).to eq({ number: 1, value: 1, fave: true })
      expect(assigned_fizzbuzz_numbers[1]).to eq({ number: 2, value: 2, fave: true })
      expect(assigned_fizzbuzz_numbers[99]).to eq({ number: 100, value: 'buzz', fave: false })
    end
    it 'success' do 
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe '#update_favourites' do
    let!(:jose) { create(:user, username: 'jose', password_digest: 'elixir') }
    let!(:chris) { create(:user, username: 'chris', password_digest: 'phoenix') }
    let!(:jose_favourite_1) { create(:favourite, number: 1, user_id: jose.id) }
    let!(:jose_favourite_2) { create(:favourite, number: 2, user_id: jose.id) }
    let!(:chris_favourite) { create(:favourite, number: 3, user_id: chris.id) }

    before(:each){
      put :update_favourites,
           session: { user_id: jose.id },
           params: { 'marked_as_favourites' => ['1', '2', '9', '15'] } 
    }
    it 'assigns the currently logged in user\'s favourites' do
      assigned_fizzbuzz_numbers = assigns(:fizzbuzz_numbers)
      expect(assigned_fizzbuzz_numbers.size).to eq 100
      expect(assigned_fizzbuzz_numbers[0]).to eq({ number: 1, value: 1, fave: true })
      expect(assigned_fizzbuzz_numbers[1]).to eq({ number: 2, value: 2, fave: true })
      expect(assigned_fizzbuzz_numbers[8]).to eq({ number: 9, value: 'fizz', fave: true })
      expect(assigned_fizzbuzz_numbers[14]).to eq({ number: 15, value: 'fizzbuzz', fave: true })
      expect(assigned_fizzbuzz_numbers[99]).to eq({ number: 100, value: 'buzz', fave: false })
    end
    it 'redirects to favourites' do 
      expect(response).to redirect_to(favourites_path)
      expect(response).to have_http_status(302)
    end
  end
end
