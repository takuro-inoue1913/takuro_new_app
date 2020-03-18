class User < ApplicationRecord
    has_many :microposts
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    
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
  
  
  
  private
    
    def downcase_email
        self.email = email.downcase
    end
    
    def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
