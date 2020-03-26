class CommentsController < ApplicationController
    
    
  def create
    @micropost = Micropost.find(params[:micropost_id]) 
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = '投稿にコメントしました。'
      redirect_to micropost_path(@micropost)
    else
      @micropost = Micropost.find(params[:micropost_id]) 
      flash.now[:danger] = '投稿へのコメントに失敗しました。'
      render 'microposts/show'
    end
  end


  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    redirect_to  request.referrer || root_url
  end



  private 

    def comment_params
      params.require(:comment).permit(:body, :picture)
    end

end
