module Api
  module V1
    # work with users
    class UsersController < ApiController
      before_action :authenticate_jwt

      def find_by_username
        if params[:username]
          users = User.public_fields.where_username_like(params[:username])
          render json: users
        else
          render json: []
        end
      end
    end
  end
end
