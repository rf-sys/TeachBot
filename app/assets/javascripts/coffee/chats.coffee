# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'click', "div[name='unread_messages_dropdown'] .dropdown-menu", (e) ->
    console.log(123)
    e.stopPropagation()