class UsersController < ApplicationController
  
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
    @user = User.find_by(params[:id])
  end
  
  
  
  def update
    @user = User.find_by (params[:id])
     if @user.update_attributes(user_params)
      
     else
       render 'edit'
     end
  end
  
  
  
  private
  
   def user_params
     params.require(:user).permit(:name, :username, :email,
                                  :password, :password_confirmation)
   end
   
end
