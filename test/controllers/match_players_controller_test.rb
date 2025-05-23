require "test_helper"

class MatchPlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get match_players_update_url
    assert_response :success
  end
end
