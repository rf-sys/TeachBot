# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
	if $('#body_courses_index').length
		$("#courses_index_subscriptions").on 'ajax:success', (event, response, status) ->
			$("#courses_index_subscriptions").html(response)
