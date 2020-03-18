class MicropostsController < ApplicationController
  before_action :logged_in_users, only: [:create, :destroy]
    
  def create
  end
  
  def destroy
  end
    
    
end
