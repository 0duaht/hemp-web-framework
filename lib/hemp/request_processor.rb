module Hemp
  class RequestProcessor
    attr_reader :request, :route

    def initialize(request, route)
      @request = request
      @route = route
    end

    def rack_response
      route ? process_request(route) : send_default_response
    end

    def process_request(route)
      request = overwite_request_params_with_merged_values_from_url(route)
      controller_constant = Object.
                            const_get(route.controller_camel)
      return error_response(controller_constant) unless controller_constant
      controller_class = controller_constant.new(request)

      obtain_appropriate_response controller_class, route
    end

    def get_params(route)
      request.params.merge(route.get_url_vars(request.path_info))
    rescue RuntimeError
      {}.merge(route.get_url_vars(request.path_info))
    end

    def overwite_request_params_with_merged_values_from_url(route)
      params = get_params(route)
      request.instance_variable_set "@params", params

      request
    end

    def obtain_appropriate_response(controller_class, route)
      controller_class.send(route.action_sym)
      response = controller_class.response

      response ? response : controller_class.render(route.action_sym)
    end

    def send_default_response
      Rack::Response.new "Hello from Hemp", 200, {}
    end

    def error_response(controller)
      Rack::Response.new "Route Error. #{controller} is not defined", 500, {}
    end
  end
end
