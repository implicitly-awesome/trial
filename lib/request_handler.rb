require 'json'

class RequestHandler
  def call(env)
    [200, {}, [ROUTER.routes.to_json]]
  end
end
