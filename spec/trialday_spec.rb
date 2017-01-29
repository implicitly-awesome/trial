require 'spec_helper'
require 'rack/test'
require 'json'

describe 'Trialday' do
  include Rack::Test::Methods

  let(:app) { Rack::Builder.parse_file('config.ru').first }

  shared_examples 'returns JSON' do
    it do
      subject
      expect(last_response['Content-Type']).to eq('application/json')
    end
  end

  shared_examples 'returns status' do |status|
    it do
      subject
      expect(last_response.status).to eq(status)
    end
  end

  describe 'GET /bla' do
    subject { get '/bla' }

    it_behaves_like 'returns status', 200
    it_behaves_like 'returns JSON'

    it 'returns {"results": [1, 2, 3]}' do
      get '/bla'
      expect(last_response.body).to eq({ results: [1, 2, 3] }.to_json)
    end
  end

  describe 'POST /bla' do
    subject { post '/bla' }

    it_behaves_like 'returns status', 200
    it_behaves_like 'returns JSON'

    it 'returns {"name": "Andrey"}' do
      post '/bla', { name: 'Andrey' }.to_json
      expect(last_response.body).to eq({ name: 'Andrey' }.to_json)
    end
  end

  context 'with unknown path' do
    subject { post '/unknown' }

    it_behaves_like 'returns status', 404
  end
end
