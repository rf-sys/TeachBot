# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$(this).whenExist '#body_chat_index', ->
		$('#new_message')
			.on 'ajax:send', ->
			  $('#message_text').val('')
			.on 'ajax:error', (event, data) ->
			  $(document).trigger('RMB:ajax', data)


		$('#chat_block').scrollTop($('#chat_block').height())

	$('#chat_block').scroll ->
		$('#chat_older_messages_btn').trigger 'click' if this.scrollTop == 0