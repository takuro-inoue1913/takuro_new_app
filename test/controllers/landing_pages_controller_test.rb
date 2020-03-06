require 'test_helper'

class LandingPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "cook share"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | cook share"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | cook share"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | cook share"
  end
end
