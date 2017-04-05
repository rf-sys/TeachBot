# handle user's posts
class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: { data: post }, status: :ok
    else
      error_message(post.errors.full_messages, 422)
    end
  end

  def destroy
    post = Post.find(params[:id])

    return fail_response(['Access denied'], 403) unless owner?(post, 'user_id')

    post.destroy
    render json: { post: params[:id], status: 'Success' }
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end

  def author(post)
    current_user.id == post.user_id
  end
end
