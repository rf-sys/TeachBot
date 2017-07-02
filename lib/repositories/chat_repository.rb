module Repositories
  module ChatRepository
    extend self

    def set_between_users(first_user, second_user)
      Chat.find_or_initialize_between(first_user, second_user)
    end

    def save(chat)
      chat.save
    end
  end
end
