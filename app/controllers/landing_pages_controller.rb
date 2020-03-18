class LandingPagesController < ApplicationController
  def home
    @micropost = current_user.micropost.bulid if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
