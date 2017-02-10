App.public_chat = App.cable.subscriptions.create "PublicChatChannel",
  connected: ->
    @appear()

  disconnected: ->
    @leave()

  received: (data) ->
    switch data.type
      when 'message' then @appendPulicChatMessage(data)
      when 'members' then @updateParticipants(data)

  appear: ->
    if $('#body_public_chat_show').length
      @perform 'appear'
      console.log 'appear'

  leave: ->
    if $('#body_public_chat_show').length
      @perform 'leave'
      console.log 'leave'

  appendPulicChatMessage: (data) ->
    if $('#body_public_chat_show').length
      @triggetMessage(data)

  updateParticipants: (users) ->
    if $('#body_public_chat_show').length
      $(document).trigger('participants', users)

  triggetMessage: (data) ->
    $(document).trigger "public_chat:receive_message", data.response

$ ->
  $(this).on 'turbolinks:load', ->
    if $('#body_public_chat_show').length
      App.public_chat.appear()

  $(this).on 'turbolinks:before-visit', ->
    if $('#body_public_chat_show').length
      App.public_chat.leave()
