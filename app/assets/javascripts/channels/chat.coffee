App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    @appear()

  disconnected: ->
    @leave()

  received: (data) ->
    console.log 'recieved_console:', data
    switch data.type
      when 'message' then @appendMessage(data)
      when 'public_chat_message' then @appendPulicChatMessage(data)
      when 'members' then @updateParticipants(data)
      when 'new_chat' then @triggerNewChatEvent(data)

  appear: ->
    if $('#body_chats_public_chat').length
      @perform 'appear'
      console.log 'appear'

  leave: ->
    if $('#body_chats_public_chat').length
      @perform 'leave'
      console.log 'leave'

  appendMessage: (data) ->
    if $('#body_chats_index').length
      @triggetMessage(data)
     #$('#chat_messages').append(data.message)
     #$('#chat_block').scrollTop($('#chat_block').height())
  appendPulicChatMessage: (data) ->
    if $('#body_chats_public_chat').length
      @triggetMessage(data)

  updateParticipants: (users) ->
    if $('#body_chats_public_chat').length
      $(document).trigger('participants', users)

  triggerNewChatEvent: (data) ->
    $(document).trigger 'chat:new_chat:action_cable', data.chat
    @perform 'subscribe_to_chat', chat_id: data.chat.id

  triggetMessage: (data) ->
    $(document).trigger "chat:#{data.response.message.chat_id}:receive_message", data.response

$ ->
  $(this).on 'turbolinks:load', ->
    if $('#body_chats_public_chat').length
      App.chat.appear()

  $(this).on 'turbolinks:before-visit', ->
    if $('#body_chats_public_chat').length
      App.chat.leave()