# public chat
class PublicChatController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = fetch_cache(PublicChat, 'public_chat') { PublicChat.take }
  end
end
