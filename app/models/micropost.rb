class Micropost < ApplicationRecord
  belongs_to :user
  
  has_many :likes, dependent: :destroy
  
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  
  
  # マイクロポストをいいねする
  def iine(user)
    likes.create(user_id: user.id)
  end


  # マイクロポストのいいねを解除する
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end
  
  
  private
  
  # アップロードされた画像のサイズをバリデーションする (上限 5MB)
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MB以上のdateは投稿できません")
      end
    end
end
