require 'spec_helper'

describe Router do
  let!(:action) { -> { 'Hello' } }
  let!(:router) { described_class.instance }

  it 'is a singleton' do
    expect { Router.new }.to raise_error(NoMethodError)
    router1 = Router.instance
    router2 = Router.instance

    expect(router1.object_id).to eq(router2.object_id)
  end

  it 'stores routes as hash' do
    expect(router.routes).to be_a(Hash)
  end

  describe '#add' do
    before { router.instance_variable_set(:@routes, {}) }

    it 'adds a route to the collection' do
      expect(router.routes).to be_empty

      router.add('/path', 'get', &action)

      expect(router.routes).not_to be_empty
    end

    it 'stores a route properly' do
      router.add('/path', 'get', &action)

      expect(router.routes).to eq({ '/path' => { get: action } })
    end

    it 'stores route per path' do
      router.add('/path', 'get', &action)
      router.add('/path', 'post', &action)

      expect(router.routes).to eq({
        '/path' => {
          get: action,
          post: action
        }
      })
    end

    it 'overrides actions by method' do
      router.add('/path', 'get', &action)
      other_action = -> { 'Bye' }
      router.add('/path', 'get', &other_action)

      expect(router.routes).to eq({ '/path' => { get: other_action } })
    end
  end
end
