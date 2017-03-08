# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(this).whenExist '#body_public_chat_show', ->
    $('#new_message')
      .on 'ajax:send', ->
        $('#message_text').val('')
      .on 'ajax:error', (event, data) ->
        $(document).trigger('RMB:ajax', data)