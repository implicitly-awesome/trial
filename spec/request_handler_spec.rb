require 'spec_helper'

describe RequestHandler do
  let!(:routes) { {} }
  let!(:request_handler) { described_class.new(routes) }

  it 'has #call/1 method' do
    expect(request_handler).to respond_to(:call)
  end
end
