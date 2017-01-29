require 'json'
##
# Instances of this class handle requests given from Rack
class RequestHandler
  DEFAULT_CONTENT_TYPE = 'application/json'

  ##
  # The entrypoint for Rack
  # @param [Hash] request environment hash
  def call(env)
    process Rack::Request.new(env)
  end

  ##
  # Processes current rack request
  # @param [Rack::Request] rack request
  def process(request)
    action = resolve_action(request)
    params = resolve_params(request)
    respond_with(action, params)
  end

  private

  ##
  # Gets params from a request and normalizes them
  # @param [Rack::Request] rack request
  def resolve_params(request)
    body = request.body.read

    return {} if body.empty?

    params = JSON.parse(body)
    normalize_params(params)
  end

  ##
  # Normalizes params hash
  # @param [Hash] params hash
  def normalize_params(params)
    params.each_with_object({}) do |(k, v), hash|
      hash[k.to_sym] = v
    end
  end

  ##
  # Normalizes request method
  # @param [Rack::Request] rack request
  def normalize_request_method(request)
    request&.request_method&.to_sym.downcase
  end

  ##
  # Gets a called action from router
  # @param [Rack::Request] rack request
  def resolve_action(request)
    request_method = normalize_request_method(request)
    ROUTER.action_for(request.path, request_method)
  end

  ##
  # Invokes an action and generates rack response
  # @param [Proc] an action
  # @param [Hash] request parameters
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

  ##
  # Generates response with 501 status
  def respond_with_501
    [501, { 'Content-Type' => DEFAULT_CONTENT_TYPE }, ['Not implemented']]
  end

  ##
  # Generates response with 500 status
  def respond_with_500
    [500, { 'Content-Type' => DEFAULT_CONTENT_TYPE }, ['Internal server error']]
  end
end
