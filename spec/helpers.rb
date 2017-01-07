# Set session_id that equals user's id
# @param [User] user
def auth_user_as(user)
    session[:user_id] = user.id
end