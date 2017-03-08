json.notifications @notifications
json.current_page @notifications.current_page
json.last_page @notifications.any? ? @notifications.last_page? : true