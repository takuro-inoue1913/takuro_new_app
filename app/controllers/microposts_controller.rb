class MicropostsController < ApplicationController
  before_action :logged_in_users, only: [:create, :destroy]
    
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿が完了しました！"
      redirect_to root_url
    else
      render 'landing_pages/home'
    end
  end
  
  def destroy
  end
    
  
  def micropost_params
      params.require(:micropost).permit(:content)
  end
  
end
