App.chat = App.cable.subscriptions.create "ChatChannel",
	connected: ->
		@appear()

	disconnected: ->
		@leave()

	received: (data) ->
		console.log data
		switch data.type
			when 'message' then @appendMessage(data)
			when 'members' then @updateParticipants(data)

	appear: ->
		if $('#body_chat_index').length
			@perform 'appear'
			console.log 'appear'

	leave: ->
		if $('#body_chat_index').length
			@perform 'leave'
			console.log 'leave'

	appendMessage: (data) ->
		$('#chat_messages').append(data.message)
		$('#chat_block').scrollTop($('#chat_block').height())

	updateParticipants: (users) ->
		$(document).trigger('participants', users)

$ ->
	$(this).on 'turbolinks:load', ->
		if $('#body_chat_index').length
			App.chat.appear()

	$(this).on 'turbolinks:before-visit', ->
		if $('#body_chat_index').length
			App.chat.leave()