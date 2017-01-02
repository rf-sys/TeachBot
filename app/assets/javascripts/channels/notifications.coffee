App.notifications = App.cable.subscriptions.create "NotificationsChannel",
	connected: ->
		@getNotificationsCount()

	disconnected: ->
# Called when the subscription has been terminated by the server

	received: (data) ->
    console.log('noti', data)
    $(document).trigger 'notifications:receive', data

	getNotificationsCount: ->
	  $(document).trigger 'notifications:count:get'

	clearNotificationsCount: ->
		$(document).trigger 'notifications:count:clear'
