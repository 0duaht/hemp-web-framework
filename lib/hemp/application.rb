require "hemp/routing/base"
require "hemp/extensions/object"
require "rack"

module Hemp
  class Application
    attr_reader :pot

    def initialize
      @pot = Hemp::Routing::Base.new
    end

    def call(env)
      request = Rack::Request.new(env)
      route = find_route(request) unless env.empty?
      [200, {}, [route ? process_request(route) : "Hello from Hemp!"]]
    end

    def find_route(request)
      verb = request.request_method.downcase.to_sym
      route = @pot.routes[verb].detect do|route_val|
        route_val == request.path_info
      end

      route
    end

    def process_request(route)
      controller_class = Hemp::ObjectHelper.
                         const_get(route.controller_camel).new
      response = controller_class.send(route.action_sym)

      response
    end
  end
end
