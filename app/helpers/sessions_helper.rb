module SessionsHelper
    
  def log_in(user)
      session[:user_id] = user.id
  end
  
  def current_user
     if session[:user_id]
         @current_user ||= User.find_by(id: session[:user_id])
         # cookiesに一時的に保存
     end
  end
  
  def logged_in?
      !current_user.nil?
       # ログインしていたらture,していなかったらfalseを返す
  end
end
