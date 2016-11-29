module UsersHelper
  def success_update
    render :json => {
        :message => 'User has been updated successfully',
        data: {
            :username => @user.username
        }
    }
  end

  def fail_update
    render :json => {:error => @user.errors.full_messages}, status: 422
  end
end
