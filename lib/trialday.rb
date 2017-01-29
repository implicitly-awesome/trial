require 'rack'
require 'request_handler'
require 'router'

KNOWN_REQUEST_METHODS = %i(get post).freeze

KNOWN_REQUEST_METHODS.each_with_index do |method, i|
  define_method(method) do |path, &action|
    # FIXME: context hell
    @routes ||= {}
    @routes[path] ||= {}
    @routes[path][method] = action
    routes = @routes

    map path do
      run RequestHandler.new(routes)
    end
  end
end
