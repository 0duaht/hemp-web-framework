require "hemp/extensions/object"
require "hemp/extensions/hash"
require "hemp/routing/base"
require "rack"

module Hemp
  class Application
    attr_reader :pot, :request, :params

    def initialize
      @pot = Hemp::Routing::Base.new
    end

    def call(env)
      @request = Rack::Request.new(env)
      route = find_route(request) unless env.empty?
      route ? process_request(route) : send_default_response
    end

    def find_route(request)
      verb = request.request_method.downcase.to_sym
      route = @pot.routes[verb].detect do|route_val|
        route_val == request.path_info
      end

      route
    end

    def process_request(route)
      controller_class = Object.
                         const_get(route.controller_camel).new
      set_request_and_params_as_instance route, controller_class
      obtain_appropriate_response(controller_class, route)
    end

    def get_params(route)
      request.params.merge(route.get_url_vars(request.path_info))
    rescue RuntimeError
      {}.merge(route.get_url_vars(request.path_info))
    end

    def set_request_and_params_as_instance(route, controller_class)
      params = get_params(route)
      request.instance_variable_set "@params", params
      controller_class.instance_variable_set "@request", request
    end

    def obtain_appropriate_response(controller_class, route)
      controller_class.send(route.action_sym)
      response = controller_class.response

      response ? response : controller_class.render(route.action_sym)
    end

    def send_default_response
      Rack::Response.new "Hello from Hemp", 200, {}
    end
  end
end
