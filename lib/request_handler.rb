require 'json'

class RequestHandler
  DEFAULT_CONTENT_TYPE = 'application/json'

  def call(env)
    process Rack::Request.new(env)
  end

  def process(request)
    action = resolve_action(request)
    params = resolve_params(request)
    respond_with(action, params)
  end

  private

  def resolve_params(request)
    body = request.body.read

    return {} if body.empty?

    params = JSON.parse(body)
    normalize_params(params)
  end

  def normalize_params(params)
    params.each_with_object({}) do |(k, v), hash|
      hash[k.to_sym] = v
    end
  end

  def normalize_request_method(request)
    request&.request_method&.to_sym.downcase
  end

  def resolve_action(request)
    request_method = normalize_request_method(request)
    ROUTER.action_for(request.path, request_method)
  end

  def respond_with(action, params)
    return respond_with_501 unless (action && action.is_a?(Proc))

    begin
      [
        200,
        { 'Content-Type' => DEFAULT_CONTENT_TYPE },
        [(action.arity == 0 ? action.call : action.call(params)).to_json]
      ]
    rescue => ex
      p "Error during action invokation: #{ex.message}"
      return respond_with_500
    end
  end

  def respond_with_501
    [501, { 'Content-Type' => DEFAULT_CONTENT_TYPE }, ['Not implemented']]
  end

  def respond_with_500
    [500, { 'Content-Type' => DEFAULT_CONTENT_TYPE }, ['Internal server error']]
  end
end
