module Repositories
  module UserRepository
    extend self

    # @param [User] user
    # @param [Hash] params
    def update(user, params)
      user.update(params)
    end

    def find(id)
      User.find_by(id: id)
    end
  end
end
