require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  test "index_returns_success" do
    get members_url
    assert_response :success
  end
  # 
  # test "index" do
  #   get members_url
  #   body = JSON.parse(response.body).symbolize_keys
  #   assert_equal("Mike", body[:test])
  # end
end
