class ChatsController < ApplicationController
  before_action :require_user

  def public_chat
    @chat = get_from_cache(Chat, 'public_chat') {Chat.public_chat}
  end

  def index
  end

end
