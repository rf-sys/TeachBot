App.chat = App.cable.subscriptions.create "ChatChannel",
  received: (data) ->
    console.log 'recieved_console:', data
    switch data.type
      when 'message' then @appendMessage(data)
      when 'new_chat' then @triggerNewChatEvent(data)
      when 'chat_notification' then @appendChatNotification(data)

  appendMessage: (data) ->
    if $('#body_chats_index').length
      @triggetMessage(data)
     #$('#chat_messages').append(data.message)
     #$('#chat_block').scrollTop($('#chat_block').height())

  triggerNewChatEvent: (data) ->
    $(document).trigger 'chat:new_chat:action_cable', data.chat
    @perform 'subscribe_to_chat', chat_id: data.chat.id

  triggetMessage: (data) ->
    $(document).trigger "chat:#{data.response.message.chat_id}:receive_message", data.response

  appendChatNotification: (data) ->
    console.log 'notification'
    $(document).trigger "chat:#{data.chat_id}:notification", data.text
