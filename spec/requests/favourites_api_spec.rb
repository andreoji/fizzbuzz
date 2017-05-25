require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Favourites API', :type => :request do

  describe 'GET /api/v1/favourites' do
    before(:all) { 
      @token = sign_in_as_a_valid_program
    }
    describe 'given pagination defaults of page=1 and per_page=100' do
      before do
        get "#{ api_v1_favourites_path }.json", headers: { 'Authorization' => "Token token=#{ @token }" }
      end
      it 'returns first 100 fizzbuzz numbers' do
        json = JSON.parse(response.body)
        expect(json.size).to eq 100
        expect(json.first).to eq({ 'number' =>  1, 'value' => 1, 'fave' => false })
        expect(json.last).to eq({ 'number' =>  100, 'value' => 'buzz', 'fave' => false })
      end
      it 'returns status code 200' do 
        expect(response.status).to eq 200
      end
      it 'content-type negotiated as application/json' do
        expect(response.content_type).to eq 'application/json'
      end
      it 'has pagination headers set'do
        expect(response.headers['X-Total-Pages']).to eq 10_000_000_000
        expect(response.headers['X-Total-Entries']).to eq 1_000_000_000_000
        expect(response.headers['X-Per-Page']).to eq 100
        expect(response.headers['X-Current-Page']).to eq 1
        expect(response.headers['X-Next-Page']).to eq 2
      end
    end
    describe 'given pagination settings of page=2 and per_page=21' do
      before do
        get "#{ api_v1_favourites_path }.json", params: { page: 2, per_page: 21 },
                                               headers: { 'Authorization' => "Token token=#{ @token }" }
      end
      it 'returns the second page of fizzbuzz numbers' do
        json = JSON.parse(response.body)
        expect(json.size).to eq 21
        expect(json.first).to eq({ 'number' =>  22, 'value' => 22, 'fave' => false })
        expect(json.last).to eq({ 'number' =>  42, 'value' => 'fizz', 'fave' => false })
      end
      it 'returns status code 200' do 
        expect(response.status).to eq 200
      end
      it 'content-type negotiated as application/json' do
        expect(response.content_type).to eq 'application/json'
      end
      it 'has pagination headers set'do
        expect(response.headers['X-Total-Pages']).to eq 47_619_047_620
        expect(response.headers['X-Total-Entries']).to eq 1_000_000_000_000
        expect(response.headers['X-Per-Page']).to eq 21
        expect(response.headers['X-Current-Page']).to eq 2
        expect(response.headers['X-Next-Page']).to eq 3
        expect(response.headers['X-Previous-Page']).to eq 1
      end
    end
  end

  describe 'PUT /api/v1/favourites' do
    before(:all) { 
      @token = sign_in_as_a_valid_program
    }
    context 'given pagination defaults of page=1 and per_page=100' do
      context 'when 1, 2, 3 are favourited' do
        before do
          put "#{ api_v1_favourites_path }.json", params: { 'marked_as_favourites' => ['1', '2', '3'] },
                                                  headers: { 'Authorization' => "Token token=#{ @token }" } 
        end
        it 'then the first page\'s favourites will be 1, 2, 3' do
          json = JSON.parse(response.body)
          expect(json.size).to eq 100
          expect(json.first).to eq({ 'number' =>  1, 'value' => 1, 'fave' => true })
          expect(json[1]).to eq({ 'number' =>  2, 'value' => 2, 'fave' => true })
          expect(json[2]).to eq({ 'number' =>  3, 'value' => 'fizz', 'fave' => true })
          expect(json.last).to eq({ 'number' =>  100, 'value' => 'buzz', 'fave' => false })
        end
        it 'returns status code 200' do 
          expect(response.status).to eq 200
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
        it 'has pagination headers set'do
          expect(response.headers['X-Total-Pages']).to eq 10_000_000_000
          expect(response.headers['X-Total-Entries']).to eq 1_000_000_000_000
          expect(response.headers['X-Per-Page']).to eq 100
          expect(response.headers['X-Current-Page']).to eq 1
          expect(response.headers['X-Next-Page']).to eq 2
        end
      end
    end
    context 'given pagination settings of page=2 and per_page=21' do
      context 'when 25,30,35 are favourited' do
        before do
          put "#{ api_v1_favourites_path }.json",
            params: { page: 2, per_page: 21, 'marked_as_favourites' => ['25', '30', '35'] },
            headers: { 'Authorization' => "Token token=#{ @token }" }
        end
        it 'then the second page\'s favourites will be 25,30,35' do
          json = JSON.parse(response.body)
          expect(json.size).to eq 21
          expect(json.first).to eq({ 'number' =>  22, 'value' => 22, 'fave' => false })
          expect(json[3]).to eq({ 'number' =>  25, 'value' => 'buzz', 'fave' => true })
          expect(json[8]).to eq({ 'number' =>  30, 'value' => 'fizzbuzz', 'fave' => true })
          expect(json[13]).to eq({ 'number' =>  35, 'value' => 'buzz', 'fave' => true })
          expect(json.last).to eq({ 'number' =>  42, 'value' => 'fizz', 'fave' => false })
        end
        it 'returns status code 200' do 
          expect(response.status).to eq 200
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
        it 'has pagination headers set'do
          expect(response.headers['X-Total-Pages']).to eq 47_619_047_620
          expect(response.headers['X-Total-Entries']).to eq 1_000_000_000_000
          expect(response.headers['X-Per-Page']).to eq 21
          expect(response.headers['X-Current-Page']).to eq 2
          expect(response.headers['X-Next-Page']).to eq 3
          expect(response.headers['X-Previous-Page']).to eq 1
        end
      end
    end
    context 'given pagination setting of page=2 and per_page=21' do
      context 'when 1 is marked as a favourite' do
        before do
          put "#{ api_v1_favourites_path }.json",
            params: { page: 2, per_page: 21, 'marked_as_favourites' => ['1'] },
            headers: { 'Authorization' => "Token token=#{ @token }" }
        end
        it 'return numbers must be within page limits error' do
          json = JSON.parse(response.body)
          expect(json).to eq({"errors" => [{"detail" => "numbers must be within page limits"}]})
        end
        it 'returns status code 400' do 
          expect(response.status).to eq 400
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
      end
    end
    context 'given pagination settings of page=2 and per_page=21' do
      context 'when 100 is marked as a favourite' do
        before do
          put "#{ api_v1_favourites_path }.json",
            params: { page: 2, per_page: 21, 'marked_as_favourites' => ['100'] },
            headers: { 'Authorization' => "Token token=#{ @token }" }
        end
        it 'return numbers must be within page limits error' do
          json = JSON.parse(response.body)
          expect(json).to eq({"errors" => [{"detail" => "numbers must be within page limits"}]})
        end
        it 'returns status code 400' do 
          expect(response.status).to eq 400
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
      end
    end
    context 'given all numbers on the second page are favourites and page=2, per_page=10)' do
      context 'when 16,17,18,19,20 are marked as favourites' do
        before :each do
          full_page_as_favourites = (11..20).map { |n| n.to_s }
          remain_as_favourites = (16..20).map { |n| n.to_s }

          put "#{ api_v1_favourites_path }.json",
            params: {page: 2, per_page: 10, 'marked_as_favourites' =>  full_page_as_favourites},
            headers: { 'Authorization' => "Token token=#{ @token }" } 

          put "#{ api_v1_favourites_path }.json",
            params: { page: 2, per_page: 10, 'marked_as_favourites' => remain_as_favourites },
            headers: { 'Authorization' => "Token token=#{ @token }" }
        end
        
        it 'then the second page\'s favourites will be 16,17,18,19,20' do
          json = JSON.parse(response.body)
          faves_and_non_faves = json.partition { |j| j['fave'] == true }
          expect(json.size).to eq 10
          expect(faves_and_non_faves[0].all? { |j| j['fave'] == true } ).to eq true
          expect(faves_and_non_faves[0].min_by { |j| j['number'] }).to eq({ "number" => 16, "value" => 16, "fave" => true })
          expect(faves_and_non_faves[0].max_by { |j| j['number'] }).to eq({ "number" => 20, "value" => 'buzz', "fave" => true })
          expect(faves_and_non_faves[1].all? { |j| j['fave'] == false } ).to eq true
          expect(faves_and_non_faves[1].min_by { |j| j['number'] }).to eq({ "number" => 11, "value" => 11, "fave" => false })
          expect(faves_and_non_faves[1].max_by { |j| j['number'] }).to eq({ "number" => 15, "value" => 'fizzbuzz', "fave" => false })
        end
        it 'returns status code 200' do 
          expect(response.status).to eq 200
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
      end
    end
    context 'given all numbers on the second page are favourites and page=2, per_page=10)' do
      context 'when all the page\'s numbers are unmarked as favourites' do
        before :each do
          full_page_as_favourites = (11..20).map { |n| n.to_s }

          put "#{ api_v1_favourites_path }.json",
            params: {page: 2, per_page: 10, 'marked_as_favourites' =>  full_page_as_favourites},
            headers: { 'Authorization' => "Token token=#{ @token }" } 

          put "#{ api_v1_favourites_path }.json",
            params: { page: 2, per_page: 10, 'marked_as_favourites' => [] },
            headers: { 'Authorization' => "Token token=#{ @token }" }
        end

        it 'then the second page\'s favourites will have no favourites' do
          json = JSON.parse(response.body)
          expect(json.size).to eq 10
          expect(json.all? { |j| j['fave'] == false } ).to eq true
          expect(json.min_by { |j| j['number'] }).to eq({ "number" => 11, "value" => 11, "fave" => false })
          expect(json.max_by { |j| j['number'] }).to eq({ "number" => 20, "value" => 'buzz', "fave" => false })
        end
        it 'returns status code 200' do 
          expect(response.status).to eq 200
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
      end
    end
    context 'given all numbers on the first page are favourites and page=1, per_page=20)' do
      context 'when 1,2,3,4,5 and 11,12,13,14,15 are unmarked as favourites' do
        before :each do
          full_page_as_favourites = (1..20).map { |n| n.to_s }

          put "#{ api_v1_favourites_path }.json",
            params: {page: 1, per_page: 20, 'marked_as_favourites' =>  full_page_as_favourites},
            headers: { 'Authorization' => "Token token=#{ @token }" } 

          put "#{ api_v1_favourites_path }.json",
            params: { page: 1, per_page: 10, 'marked_as_favourites' => ['6', '7', '8', '9', '10'] },
            headers: { 'Authorization' => "Token token=#{ @token }" }

          put "#{ api_v1_favourites_path }.json",
            params: { page: 2, per_page: 10, 'marked_as_favourites' => ['16', '17', '18', '19', '20'] },
            headers: { 'Authorization' => "Token token=#{ @token }" }

          get "#{ api_v1_favourites_path }.json",
            params: { page: 1, per_page: 20 },
            headers: { 'Authorization' => "Token token=#{ @token }" }
        end

        it 'then the first page\'s favourites will be 6,7,8,9,10 and 16,17,18,19,20' do
          json = JSON.parse(response.body)
          faves_and_non_faves = json.slice_when { |x, y| x['fave'] != y['fave'] }.to_a
          expect(json.size).to eq 20 
          expect(faves_and_non_faves[0].all? { |j| j['fave'] == false } ).to eq true
          expect(faves_and_non_faves[0].min_by { |j| j['number'] }).to eq({ "number" => 1, "value" => 1, "fave" => false })
          expect(faves_and_non_faves[0].max_by { |j| j['number'] }).to eq({ "number" => 5, "value" => 'buzz', "fave" => false })

          expect(faves_and_non_faves[1].all? { |j| j['fave'] == true } ).to eq true
          expect(faves_and_non_faves[1].min_by { |j| j['number'] }).to eq({ "number" => 6, "value" => 'fizz', "fave" => true })
          expect(faves_and_non_faves[1].max_by { |j| j['number'] }).to eq({ "number" => 10, "value" => 'buzz', "fave" => true })

          expect(faves_and_non_faves[2].all? { |j| j['fave'] == false } ).to eq true
          expect(faves_and_non_faves[2].min_by { |j| j['number'] }).to eq({ "number" => 11, "value" => 11, "fave" => false })
          expect(faves_and_non_faves[2].max_by { |j| j['number'] }).to eq({ "number" => 15, "value" => 'fizzbuzz', "fave" => false })
          
          expect(faves_and_non_faves[3].all? { |j| j['fave'] == true } ).to eq true
          expect(faves_and_non_faves[3].min_by { |j| j['number'] }).to eq({ "number" => 16, "value" => 16, "fave" => true })
          expect(faves_and_non_faves[3].max_by { |j| j['number'] }).to eq({ "number" => 20, "value" => 'buzz', "fave" => true })
        end
        it 'returns status code 200' do 
          expect(response.status).to eq 200
        end
        it 'content-type negotiated as application/json' do
          expect(response.content_type).to eq 'application/json'
        end
        it 'has pagination headers set'do
          expect(response.headers['X-Total-Pages']).to eq 50_000_000_000
          expect(response.headers['X-Total-Entries']).to eq 1_000_000_000_000
          expect(response.headers['X-Per-Page']).to eq 20
          expect(response.headers['X-Current-Page']).to eq 1
          expect(response.headers['X-Next-Page']).to eq 2
          expect(response.headers['X-Previous-Page']).to eq nil 
        end
      end
    end
  end
end
