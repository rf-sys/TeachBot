class PostsController < ApplicationController
  before_action :require_user

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render :json => {data: post}, status: :ok
    else
      error_message(post.errors.full_messages, 422)
    end
  end

  def destroy
    post = Post.find(params[:id])

    unless author_of_the_post(post)
      return invalid_request_message(['Access denied'], 403)
    end

    post.destroy
    render :json => {post: params[:id], status: 'Success'}
  end

  private
  def post_params
    params.require(:post).permit(:title, :text)
  end

  def author_of_the_post(post)
    current_user.id == post.user_id
  end
end
