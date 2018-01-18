require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    assert_response :success
  end
end
