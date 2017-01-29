require 'rack'
require 'request_handler'
require 'router'

KNOWN_REQUEST_METHODS = %i(get post).freeze

ROUTER = Router.instance

# dynamically defines methods of KNOWN_REQUEST_METHODS names
# each method takes two params: URL path and an action's block
KNOWN_REQUEST_METHODS.each_with_index do |method, i|
  define_method(method) do |path, &action|
    ROUTER.add(path, method, &action)

    # creates a request handler for each URL path and adds it to rack's URLs mapping
    map path do
      run RequestHandler.new
    end
  end
end
