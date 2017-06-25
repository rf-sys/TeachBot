module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if cookies.signed[:live_user_id].present?
        if (current_user = User.select(:id, :username, :avatar, :slug).find_by(id: cookies.signed[:live_user_id]))
          current_user
        else
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end
  end
end
