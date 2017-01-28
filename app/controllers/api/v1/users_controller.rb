class Api::V1::UsersController < ApiController
  before_action :authenticate_jwt

  def find_by_username
    if params[:username]
      users = User.select(:id, :username, :avatar).where('username LIKE ?', "%#{params[:username]}%").limit(10)
      render json: users
    else
      render json: []
    end
  end
end
