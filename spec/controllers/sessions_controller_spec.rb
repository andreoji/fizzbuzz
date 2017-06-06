require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe 'POST #create' do
    let!(:jose) { create(:user, username: 'jose', password: 'elixir') }
    context 'given a valid password' do
      before(:each) {
        post :create, params: { username: jose.username, password: jose.password }
      }
      it 'sets the user in the session' do
        expect(controller.current_user).to eq jose
      end
      it 'redirects to favourites_path' do
        expect(response).to redirect_to favourites_path 
      end
    end
    context 'given an invalid password' do
      before(:each) {
        post :create, params: { username: jose.username, password: 'phoenix' }
      }
      it 'does not set the user in the session' do
        expect(controller.current_user).to be_nil 
      end
      it 'redirects to  login_path' do
        expect(response).to redirect_to login_path 
      end
    end
  end

  describe '#destroy' do
    it 'redirects to  login_path' do
      delete :destroy
      expect(response).to redirect_to "#{ login_path }?notice=Logged+out"
    end
  end
end
