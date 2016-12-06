module UsersHelper
  def success_update
    render :json => {
        :message => 'User has been updated successfully',
        data: {
            :username => @user.username
        }
    }
  end
end
