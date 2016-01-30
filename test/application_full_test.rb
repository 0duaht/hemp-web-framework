require_relative "test_helper"

class TestFullApplication < Minitest::Test
  attr_reader :full_application, :env, :file, :controller,
              :new_view, :show_view, :folder

  def setup
    @env = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/users/new",
      "RACK_INPUT" => ""
    }
    set_up_full_app_and_routes
  end

  def teardown
    File.delete @controller
    FileUtils.rm_rf "app"
  end

  def set_up_full_app_and_routes
    setup_instance_vars
    prepare_route
    create_controller_view_new
    create_controller_view_show
    create_controller_file
  end

  def setup_instance_vars
    @full_application = Hemp::Application.new
    @controller = "users_controller.rb"
    @folder = "app/views/users"
    @new_view = "#{folder}/new.erb"
    @show_view = "#{folder}/show.erb"
  end

  def prepare_route
    full_application.pot.prepare do
      resources :users
      get "/", to: "users#root"
    end
  end

  def create_controller_file
    File.open(controller, "w") do |file|
      file.write(controller_class_body)
      current_dir = File.expand_path("..", file)
      $LOAD_PATH.unshift current_dir
    end
  end

  def create_controller_view_new
    FileUtils.mkdir_p folder
    File.open(new_view, "w") do |file|
      file.write(new_view_body)
    end
  end

  def create_controller_view_show
    FileUtils.mkdir_p folder
    File.open(show_view, "w") do |file|
      file.write(show_view_body)
    end
  end

  def controller_class_body
    <<-STRING
      require "hemp/controller"
      class UsersController < Hemp::BaseController
        def new
          @framework = "hempified"
        end

        def show
          @name = params[:id]
          @http_verb = request.request_method
        end

        def root
          redirect_to "/users/new"
        end
      end
    STRING
  end

  def new_view_body
    "A whiff of <%= framework %> surreallism"
  end

  def show_view_body
    "Hello <%= name.capitalize %>. HTTP method is <%= http_verb.upcase %>"
  end

  def test_visiting_added_route_calls_controller_and_action
    response = full_application.call(env)
    assert_equal response.body, ["A whiff of hempified surreallism"]
  end

  def test_visiting_route_with_url_variable
    env["PATH_INFO"] = "/users/tobi"
    response = full_application.call(env)
    assert_equal response.body, ["Hello Tobi. HTTP method is GET"]
  end

  def test_response_for_route_not_defined
    env["PATH_INFO"] = "/user/page"
    response = full_application.call(env)
    assert_equal response.body, ["Hello from Hemp"]
  end

  def test_redirect
    env["PATH_INFO"] = "/"
    response = full_application.call(env)
    assert_equal response.body, []
    assert_equal response.status, 302
    assert_equal response.headers, "Location": "/users/new"
  end
end
