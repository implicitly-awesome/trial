require 'spec_helper'

describe RequestHandler do
  let!(:action) { -> { 'Hello' } }
  let!(:router) { Router.instance }
  let!(:routes) { router.add('/path', 'get', &action) }
  let!(:request_handler) { described_class.new }

  it 'has #call/1 method' do
    expect(request_handler).to respond_to(:call)
  end
end
