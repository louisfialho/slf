require 'test_helper'

class Item::StepsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get item_steps_show_url
    assert_response :success
  end

  test "should get update" do
    get item_steps_update_url
    assert_response :success
  end

end
