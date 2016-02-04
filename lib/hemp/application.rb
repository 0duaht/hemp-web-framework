require "hemp/extensions/object"
require "hemp/extensions/hash"
require "hemp/routing/base"
require "hemp/request_processor"
require "rack"

module Hemp
  class Application
    attr_reader :route_pot, :request, :params

    def initialize
      @route_pot = Hemp::Routing::Base.new
    end

    def call(env)
      @request = Rack::Request.new(env)
      route = find_route(request) unless env.empty?
      processor = RequestProcessor.new(request, route)

      processor.rack_response
    end

    def find_route(request)
      verb = request.request_method.downcase.to_sym
      route = @route_pot.routes[verb].detect do|route_val|
        route_val == request.path_info
      end

      route
    end
  end
end
