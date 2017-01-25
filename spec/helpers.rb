# Set session_id that equals user's id
# @param [User] user
def auth_as(user)
    session[:user_id] = user.id
end

def set_json_request
    request.env['HTTP_ACCEPT'] = 'application/json'
end