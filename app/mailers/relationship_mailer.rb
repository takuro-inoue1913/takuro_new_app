class RelationshipMailer < ApplicationMailer
    
    def follow_notification(user, follower)
      @user = user
      @follower = follower
      mail to: user.email, subject: "#{@follower.name}さんがあなたをフォローしました"
    end

    def unfollow_notification(user, follower)
      @user = user
      @follower = follower
      mail to: user.email, subject: "#{@follower.name}さんがあなたのフォローを外しました"
    end
end
