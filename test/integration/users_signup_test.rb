require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    # signup 失敗するテスト
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, 
      params: { user: { name: " ",
                       email: "baduser@invalid",
                       username: " ",
                       password: "foo",
                       password_confirmation: "bar" }}
    end
    assert_template 'users/new'
  end
  

  test "valid signup information" do
    # signup 成功するテスト
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path,
      params: { user: { name:  "Example User",
                      email: "user@example.com",
                      username: "test user",
                      password:              "password",
                      password_confirmation: "password" } }
    end
    follow_redirect!
    # assert_template 'users/show'
    # assert is_logged_in?
  end
end