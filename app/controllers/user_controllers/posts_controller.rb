class UserControllers::PostsController < ApplicationController
  def index
    posts = Post.select(:id, :title, :text, :created_at)
                 .where(:user_id => params[:user_id]).order(created_at: :desc).page(params[:page]).per(5)

    render :json => {
        posts: posts, total_pages: posts.total_pages, current_page: posts.current_page
    }
  end
end
