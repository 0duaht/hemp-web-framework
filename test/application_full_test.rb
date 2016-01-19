require_relative "test_helper"

class UsersController
  def new
    "new user created"
  end
end

class TestFullApplication < Minitest::Test
  attr_reader :full_application, :env

  def setup
    @env = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/users/new"
    }
    set_up_full_app_and_routes
  end

  def set_up_full_app_and_routes
    @full_application = Hemp::Application.new
    full_application.pot.prepare do
      get "/users/new", to: "users#new"
    end
  end

  def test_visiting_added_route_calls_controller_and_action
    response = Array.new(full_application.call(env))
    assert_equal response[2], ["new user created"]
  end
end
