require 'singleton'

class Router
  include Singleton

  attr_reader :routes

  def initialize
    @routes = {}
  end

  def add(path, method, &action)
    actions = @routes[path] || {}
    actions[method.to_sym] = action
    @routes[path] = actions
  end
end
