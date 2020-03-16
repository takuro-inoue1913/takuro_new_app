require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Foobar", email: "sample@foobar.com", username: "Foobar2",
                     password: "hogehoge", password_confirmation: "hogehoge", phone_number: "09012345678")
  end
  
  
  
  test "should be valid" do
    assert @user.valid?
  end
  

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end
  
  test "username should be present" do
    @user.username = "  "
    assert_not @user.valid?
  end
  
   test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end
  
  
   test "phone number test" do
     @user.phone_number = "12345678900"
     assert_not @user.valid?
   end
  
  
  test "testing name length" do
    @user.name = "a" * 31
    # 最大30文字
    assert_not @user.valid?
  end
  
  
  test "testing username length" do
    @user.username = "a" * 31
    # 最大30文字
    assert_not @user.valid?
  end
   
   
  test "testing email length" do
    @user.email = "a" * 188 + "@hogehoge.com"
    # 最大200文字
    assert_not @user.valid?
  end
  
  
  test "testing self_introduction length" do
    @user.self_introduction = "a" * 301
    # 最大300文字
    assert_not @user.valid?
  end
  
  
  test "test valid email" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect}を有効にしてください"
   end
  end
  
  test "test not valid email" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect}を無効にしてください"
    end
  end
  
  test "email addresses should be unique" do
    user = @user.dup
    # userの複製
    user.email = @user.email.upcase
    # emailの大文字入力
      @user.save
      assert_not user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    # emailの大文字入力を小文字化
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "empty password" do
    @user.password              = " " * 6
    @user.password_confirmation = " " * 6
    # passwordの空入力
    assert_not @user.valid?
  end
  
  test "minimum password length" do
    @user.password              = "a" * 5
    @user.password_confirmation = "a" * 5
    # passwordの最小入力数
    assert_not @user.valid?
  end
  
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
