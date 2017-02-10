module Repositories
  module MessageRepository
    extend self

    # @param [User] author
    # @param [Chat] chat
    # @param [Hash] params
    def initialize_new_message(author, chat, params)
      message = Message.new(params)
      message.user = author
      message.chat = chat
      message
    end

    # @param [Message] message
    def valid?(message)
      message.valid?
    end
  end
end
