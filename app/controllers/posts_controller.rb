# handle user's posts
class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = current_user.posts.new(post_params)
    fail_response(@post.errors.full_messages, 422) unless @post.save
  rescue SocketError
    fail_response(['Resource is unavailable'], 403)
  end

  def destroy
    post = Post.find(params[:id])

    return fail_response(['Access denied'], 403) unless owner?(post, 'user_id')

    post.destroy
    render json: { post: params[:id], status: 'Success' }
  end

  private

  def post_params
    params.require(:post).permit(:text, attachments_attributes: %i[
                                   title image type url
                                 ])
  end
end
