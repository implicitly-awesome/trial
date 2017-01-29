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

  def action_for(path, method)
    routes[path]&.fetch(method, nil)
  end
end
