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
      flash[:success] = "登録が完了しました！早速写真を投稿してみましょう！"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  
  
  private
  
   def user_params
     params.require(:user).permit(:name, :username, :email,
                                  :password, :password_confirmation)
   end
   
end
