require "test_helper"

class AwardsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get awards_create_url
    assert_response :success
  end
end
