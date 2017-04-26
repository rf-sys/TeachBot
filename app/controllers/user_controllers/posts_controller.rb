class UserControllers::PostsController < ApplicationController
  def index
    user = User.friendly.find(params[:user_id])
    @posts = Post.includes(:attachments).where(user: user).order(created_at: :desc)
                 .page(params[:page]).per(5)
  end
end
