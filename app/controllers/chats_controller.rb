class ChatsController < ApplicationController
  before_action :require_user

  def public_chat
    @chat = get_from_cache(Chat, 1)
  end

  def index
  end

end
