require "test_helper"

class SectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get sections_show_url
    assert_response :success
  end
end
