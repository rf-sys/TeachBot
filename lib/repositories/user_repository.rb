module Repositories
  module UserRepository
    extend self

    # @param [User] user
    # @param [Hash] params
    def update(user, params)
      user.update(params)
    end
  end
end
