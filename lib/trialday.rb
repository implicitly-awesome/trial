require 'rack'
require 'request_handler'
require 'router'

KNOWN_REQUEST_METHODS = %i(get post).freeze

ROUTER = Router.instance

KNOWN_REQUEST_METHODS.each_with_index do |method, i|
  define_method(method) do |path, &action|
    ROUTER.add(path, method, &action)

    map path do
      run RequestHandler.new
    end
  end
end
