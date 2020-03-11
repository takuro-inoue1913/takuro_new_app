require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  
  test "unsuccessful edit test" do
    # 編集失敗テスト
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              username: "",
                                              email: "foo@bad", 
                                              password: "fo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end
  
  
  test "successful edit test" do 
    # 編集失敗テスト
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo bar"
    username = "samle name"
    email = "foo@bra.com"
    patch user_path(@user), params: { user: { name: name,
                                              username: username,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal username, @user.username
    assert_equal email, @user.email
  end
end
