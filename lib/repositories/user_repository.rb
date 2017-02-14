module Repositories
  module UserRepository
    extend self

    # @param [User] user
    # @param [Hash] params
    def update(user, params)
      user.update(params)
    end

    def find_by_id(id)
      User.find_by_id(id)
    end
  end
end
