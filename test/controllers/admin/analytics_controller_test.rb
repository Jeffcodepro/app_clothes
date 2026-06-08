require "test_helper"

class Admin::AnalyticsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_analytics_index_url
    assert_response :success
  end
end
