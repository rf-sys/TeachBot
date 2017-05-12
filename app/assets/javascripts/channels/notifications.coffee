App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  received: (data) ->
    console.log(data);
    $(document).trigger 'notifications:receive', data