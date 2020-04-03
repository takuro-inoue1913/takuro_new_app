class User < ApplicationRecord
    has_many :active_relationships,  class_name: "Relationship",
                                    foreign_key: "follower_id",
                                      dependent: :destroy
    
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                      dependent: :destroy
                                    
    has_many :following, through: "active_relationships",
                          source: "followed"
    # == @user.active_relationships.map(&:followed)
    
    has_many :followers, through: "passive_relationships",
                          source: "follower"
    # == @user.passive_relationships.map(&:follower)
    
    has_many :microposts, dependent: :destroy

    has_many :likes, dependent: :destroy
    
    has_many :comments,  dependent: :destroy
    
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    mount_uploader :image, ImageUploader
    
    scope :search_by_keyword, -> (keyword) {
    where("users.name LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
    }
    
    validates :name,  presence: true, length:{ maximum: 30 }
    
    validates :username,  presence: true, length:{ maximum: 30 }
    
    validates :self_introduction, length:{ maximum: 300 }
    
    validates :phone_number, format: { with: /\A0[7-9]0-?\d{4}-?\d{4}\z/ }, allow_nil: true
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length:{ maximum: 200 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
   has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    # , on: :facebook_login
    
    
    # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  
   # ランダムな文字列を作る
  def User.new_token
     SecureRandom.urlsafe_base64
  end
  
  
   # ハッシュ値をデータベースに保存
  def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end



  # アカウント有効化
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  
  # 有効化用のメールを送る
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  
  # パスワードリセットの属性を設定
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  
  # パスワードリセット用のメールを送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  
  
  
   # ユーザーをフォローする
  def follow(other_user)
    following << other_user
    # active_relationships.create(followed_id: other_user.id)
    if other_user.follow_notification
      Relationship.send_follow_email(other_user, self)
    end
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
    if other_user.follow_notification
      Relationship.send_unfollow_email(other_user, self)
    end
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  


  def self.from_omniauth(auth)
    # emailの提供は必須とする
    user = User.where('email = ?', auth.info.email).first
   if user.blank?
     user = User.new
   end
    user.uid   = auth.uid
    user.name  = auth.info.name
    user.email = auth.info.email
    user.icon  = auth.info.image
    user.oauth_token      = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user
  end 
  
  
  
  private
  
  
    
    def downcase_email
        self.email = email.downcase
    end
    
    def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
