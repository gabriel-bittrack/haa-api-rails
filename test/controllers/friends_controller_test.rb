require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "index_returns_success" do
    get friends_url
    assert_response :success
  end
end
