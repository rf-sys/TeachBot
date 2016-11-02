module UsersHelper
  def success_update
    render :json => {
        :message => 'User has been updated successfully',
        data: {
            :username => @user.username,
            :email => @user.email,
            :avatar => params[:user][:avatar]
        }
    }
  end

  def fail_update
    render :json => {:error => @user.errors.full_messages}, status: 422
  end
end
