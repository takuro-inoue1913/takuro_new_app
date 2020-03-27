require 'test_helper'

class RelationshipMailerTest < ActionMailer::TestCase
  
  test "follow_notification" do
    user = users(:archer)
    follower = users(:lana)
    mail = RelationshipMailer.follow_notification(user, follower)
    assert_equal "#{follower.name}さんがあなたをフォローしました", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match follower.name, mail.body.encoded
  end

  test "unfollow_notification" do
    user = users(:archer)
    follower = users(:lana)
    mail = RelationshipMailer.unfollow_notification(user, follower)
    assert_equal "#{follower.name}さんがあなたのフォローを外しました", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match follower.name, mail.body.encoded
  end
end
