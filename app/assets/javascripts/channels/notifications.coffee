App.notifications = App.cable.subscriptions.create "NotificationsChannel",
	connected: ->
		@triggerGetNotificationsCount()

	disconnected: ->
# Called when the subscription has been terminated by the server

	received: (data) ->
    $(document).trigger 'notifications:receive', data

	triggerGetNotificationsCount: ->
	  $(document).trigger 'notifications:count:get'