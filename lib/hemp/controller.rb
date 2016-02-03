require "tilt/erubis"
require "tilt"
require "facets"
require "ostruct"
require "rack"

module Hemp
  class BaseController
    attr_reader :response, :request

    def render(action, instance_vars = get_instance_vars)
      controller_folder = self.class.name.pathize.split("_").first
      tilt_template = get_tilt_template(controller_folder, action)
      instance_vars.delete_field :request
      set_response(tilt_template.render(instance_vars))
    end

    def get_tilt_template(controller_folder, action)
      template_file = File.join(
        RACK_ROOT, "app", "views", controller_folder, "#{action}.html.erb"
      )

      Tilt.new template_file
    end

    def get_instance_vars
      vars = instance_variables
      instance_vars = {}

      OpenStruct.new(pile_up_instance_vars(vars, instance_vars))
    end

    def pile_up_instance_vars(vars, instance_vars)
      vars.each do |var|
        trimmed_var = var[1..-1]
        instance_vars[trimmed_var] = instance_variable_get "@#{trimmed_var}"
      end

      instance_vars
    end

    def redirect_to(location)
      set_response [], 302, "Location" => location
    end

    def set_response(body, status = 200, headers = {})
      @response = Rack::Response.new(body, status, headers)
    end

    def params
      @params ||= OpenStruct.new(request.params)
    end
  end
end
