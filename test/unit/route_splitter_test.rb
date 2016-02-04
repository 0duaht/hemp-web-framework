require_relative "../test_helper"

class TestRouteSplitter < Minitest::Test
  attr_reader :split_route

  def setup
    path_list = ["user", "apps", ":id"]
    @split_route = Hemp::Routing::RouteSplitter.new path_list
    split_route.pick_out_url_variables
  end

  def test_that_it_picks_out_url_variables_successfully
    assert_equal split_route.url_variable_hash[2], :id
  end

  def test_that_it_saves_correct_regex
    assert_equal split_route.url_regex_match.join("/"),
                 "user/apps/[a-zA-Z0-9_]+"
  end
end
