require 'json'

class RequestHandler
  attr_reader :routes

  def initialize(routes)
    @routes = routes
  end

  def call(env)
    [200, {}, [routes.to_json]]
  end
end