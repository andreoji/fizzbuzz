require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do

  describe 'POST #create' do
    context 'given a valid password' do
      let!(:api_client) { create(:user, username: 'api_client', password: 'elixir') }
      before(:each) {
        post :create, params: { username: api_client.username, password: api_client.password }
      }
      it 'returns an authentication token' do
        json = JSON.parse(response.body)
        api_client.reload
        expect(json['token']).to eq api_client.token
      end
      it 'returns a status code 200' do
        expect(response.status).to eq 200
      end
    end
    context "given invalid password" do
      let!(:api_client) { create(:user, username: 'api_client', password: 'elixir') }
      before(:each) {
        post :create, params: { username: api_client.username, password: 'invalidpassword' }
      }
      it "returns Error with your login or password" do
        json = JSON.parse(response.body)
        expect(json).to eq({"errors" => [{"detail"=>"Error with your login or password"}]})
      end
      it 'returns a status code 401' do
        expect(response.status).to eq 401
      end
    end
  end
  describe '#destroy' do
    before(:each) do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{ sign_in_as_a_valid_program }"
    end
    it 'returns a 200 status code' do
      get :destroy
      expect(response.status).to eq 200 
    end
  end
end
