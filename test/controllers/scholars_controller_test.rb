require 'test_helper'

class ScholarsControllerTest < ActionDispatch::IntegrationTest
  test "index_returns_success" do
    get scholars_url
    assert_response :success
  end
end
