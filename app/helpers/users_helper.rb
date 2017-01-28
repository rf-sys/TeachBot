module UsersHelper
  # removes user from users array
  def users_exclude_current(users, current_user)
    users - [current_user]
  end

  def success_update(user)
    render :json => {
        :message => 'User has been updated successfully',
        data: {
            :username => user.username
        }
    }
  end
end
