module UsersHelper
  # removes user from users array
  def users_exclude_current(users, current_user)
    users - [current_user]
  end

  def success_update(user)
    flash[:success_notice] = 'Success update'
    redirect_to user_path(user)
  end
end
