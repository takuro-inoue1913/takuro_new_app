class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(   email: params[:session][:email].downcase,
                        username: params[:session][:username])
                        
    if user && user.authenticate(params[:session][:password])
      
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
  end
  
end
