require_relative "../test_helper"

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
    create_controller_file
  end

  def setup_instance_vars
    @full_application = Hemp::Application.new
    @controller = "users_controller.rb"
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

  def controller_class_body
    <<-STRING
      require "hemp/controller"
      class UsersController < Hemp::BaseController
        def root
          redirect_to "/users/new"
        end
      end
    STRING
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
    assert_equal response.headers, "Location" => "/users/new"
  end
end
