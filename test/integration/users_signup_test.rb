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
end
