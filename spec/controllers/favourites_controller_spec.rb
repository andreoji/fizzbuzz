require 'rails_helper'

RSpec.describe FavouritesController, :type => :controller do

  describe '#index' do
    let!(:jose){create(:user, username: 'jose', password_digest: 'elixir')}
    let!(:chris){create(:user, username: 'chris', password_digest: 'phoenix')}
    let!(:jose_favourite){create(:favourite, number: 1, user_id: jose.id)}
    let!(:jose_other_favourite){create(:favourite, number: 2, user_id: jose.id)}
    let!(:chris_favourite){create(:favourite, number: 3, user_id: chris.id)}

    before(:each){
      get :index, session: {user_id: jose.id}
    }
    it 'assigns the currently logged in user favourites' do
      expect(assigns(:favourites)).to eq [jose_favourite, jose_other_favourite] 
    end
    it 'success' do 
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
