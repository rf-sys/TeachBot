# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$(this).whenExist "#body_lessons_new", ->
		$('#new_lesson')
			.on 'ajax:success', (e, response) ->
			  $(document).trigger('RMB:success', response.message)