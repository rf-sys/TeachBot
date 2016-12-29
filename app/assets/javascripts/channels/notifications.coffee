App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  connected: ->
    console.log 'notifications'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
	  $(document).trigger 'notification:receive', data
