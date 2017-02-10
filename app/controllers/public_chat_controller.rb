class PublicChatController < ApplicationController
  before_action :require_user

  def show
    @chat = get_from_cache(PublicChat, 'public_chat') { PublicChat.take }
  end
end
