App.unread_messages = App.cable.subscriptions.create "UnreadMessagesChannel",
  connected: ->
# Called when the subscription is ready for use on the server

  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->
    console.log data
    switch data.type
      when 'unread_messages:add' then $(document).trigger 'unread_messages:add'
      when 'unread_messages:remove' then $(document).trigger 'unread_messages:remove'
