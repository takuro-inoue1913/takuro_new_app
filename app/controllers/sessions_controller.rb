class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(   email: params[:session][:email].downcase,
                        username: params[:session][:username])
                        
    if user && user.authenticate(params[:session][:password])
       if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
       else
        message  = "アカウントが有効化されていません"
        message += "EMailをチェックし、記載されているURLをクリックしてください"
        flash[:warning] = message
        redirect_to root_url
       end
    else
      flash.now[:danger] = 'User name, email, password いずれかが間違っています。'
      render 'new'
    end
  end
  
  
  
  def destroy
    log_out if logged_in?
    # current_userがnilになるのを防ぐ
    redirect_to root_url
  end
  
end
