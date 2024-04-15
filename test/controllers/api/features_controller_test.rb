require "test_helper"

class Api::FeaturesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_features_index_url
    assert_response :success
  end

  test "should get show" do
    get api_features_show_url
    assert_response :success
  end

  test "should get create_comment" do
    get api_features_create_comment_url
    assert_response :success
  end
end
