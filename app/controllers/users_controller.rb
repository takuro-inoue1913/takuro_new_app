class UsersController < ApplicationController
  before_action :logged_in_users, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  
  def index
     @users = User.paginate(page: params[:page])
  end
  
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "登録が完了しました！早速写真を投稿してみましょう！"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  
  def edit
    @user = User.find(params[:id])
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
  
  
  
  
  private
  
   def user_params
     params.require(:user).permit(:name, :username, :email,
                                  :password, :password_confirmation,
                                  :webpage , :self_introduction,
                                  :phone_number, :sex)
   end
   
   def logged_in_users
     if not logged_in?
       store_location
       flash[:danger] = "ログインしてください。"
       redirect_to login_url
     end
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
