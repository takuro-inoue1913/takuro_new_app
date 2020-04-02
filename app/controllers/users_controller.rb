class UsersController < ApplicationController
  before_action :logged_in_users, only: [:index, :edit, :update, :destroy,
                                         :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  
  def index
     @users = User.paginate(page: params[:page])
  end
  
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create

    if env['omniauth.auth'].present?
      # Facebookログイン
      @user  = User.from_omniauth(env['omniauth.auth'])
      result = @user.save(context: :facebook_login)
      fb       = "Facebook"
    else
       # 通常サインアップ
      @user = User.new(user_params)
      result = @user.save
      fb   = ""
    end

    if result
      @user.send_activation_email
      flash[:info] = "入力されたアドレスにMailを送りました。Mailのリンクをクリックして登録完了してください"
      redirect_to root_url
    else
      if fb.present?
        redirect_to auth_failure_path
      else
        render 'new'
      end
    end
    
  end
  
  
  def edit
    @user = User.find(params[:id])
    @user.image.cache! unless @user.image.blank?
  end
  
  
  def update
    @user = User.find(params[:id])
     if @user.update_attributes(user_params)
       flash[:success] = "プロフィールの更新が完了しました！"
       redirect_to @user
     else
       render 'edit'
     end
  end
  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました"
    redirect_to users_url
  end
  
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  

  
  
  private
  
   def user_params
     params.require(:user).permit(:name, :username, :email,
                                  :password, :password_confirmation,
                                  :webpage , :self_introduction,
                                  :phone_number, :sex, :image, :image_cache,
                                  :follow_notification)
   end
   
   
   
   # 正しいユーザーかテスト
   def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) if not @user == current_user
   end
   
   def admin_user
      redirect_to(root_url) unless current_user.admin?
   end
    
end
