class User < ApplicationRecord
    attr_accessor :remember_token
    
    before_save { self.email = email.downcase }
    
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
  
   # remember_tokenとremember_digest(model)の認証
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
