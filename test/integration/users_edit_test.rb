require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  
  test "unsuccessful edit test" do
    # 編集失敗テスト
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              username: "",
                                              email: "foo@bad", 
                                              password: "fo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end 
end
