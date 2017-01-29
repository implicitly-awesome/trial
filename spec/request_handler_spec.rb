require 'spec_helper'

describe RequestHandler do
  let!(:action) { -> { 'Hello' } }
  let!(:router) { Router.instance }
  let!(:routes) { router.add('/path', 'get', &action) }
  let!(:rack_request) { Rack::Request.new({}) }
  let!(:request_handler) { described_class.new }
  let!(:response_500) { [500, { 'Content-Type' => RequestHandler::DEFAULT_CONTENT_TYPE }, ['Internal server error']] }
  let!(:response_501) { [501, { 'Content-Type' => RequestHandler::DEFAULT_CONTENT_TYPE }, ['Not implemented']] }

  before do
    allow(rack_request).to receive(:request_method) { 'GET' }
    allow(rack_request).to receive(:path) { '/path' }
    allow(rack_request).to receive(:body) { OpenStruct.new(read: '{}') }
  end

  it 'has #call/1 method' do
    expect(request_handler).to respond_to(:call)
  end

  describe '#call/1' do
    it 'invokes .process/1 with Rack::Request' do
      allow(Rack::Request).to receive(:new) { rack_request }
      expect(request_handler).to receive(:process).with(rack_request)

      request_handler.call({})
    end
  end

  describe '#process/1' do
    it 'invokes an action from routes by path and method' do
      expect(action).to receive(:call)

      request_handler.process(rack_request)
    end

    it 'returns json of action result as body of 200 response' do
      expect(request_handler.process(rack_request)).to eq([
        200,
        { 'Content-Type' => RequestHandler::DEFAULT_CONTENT_TYPE },
        [action.call().to_json]
      ])
    end

    context 'when action was not found' do
      before do
        allow(rack_request).to receive(:request_method) { 'POST' }
      end

      it 'returns 501 response' do
        expect(request_handler.process(rack_request)).to eq(response_501)
      end
    end

    context 'when action invokation raises an error' do
      let(:action) { -> { raise 'oops' } }

      it 'returns 500 response' do
        expect(request_handler.process(rack_request)).to eq(response_500)
      end
    end
  end
end
