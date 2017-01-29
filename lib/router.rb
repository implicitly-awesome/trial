require 'singleton'

##
# Routes registry
class Router
  include Singleton

  attr_reader :routes

  def initialize
    @routes = {}
  end

  ##
  # Creates and adds route to the registry
  # @param [String] URL path
  # @param [String] HTTP request method
  # @param [Proc] an action
  def add(path, method, &action)
    actions = @routes[path] || {}
    actions[method.to_sym] = action
    @routes[path] = actions
  end

  ##
  # Fetches an action from the routes registry
  # @param [String] URL path
  # @param [String|Symbol] HTTP request method
  def action_for(path, method)
    routes[path]&.fetch(method.to_sym, nil)
  end
end
