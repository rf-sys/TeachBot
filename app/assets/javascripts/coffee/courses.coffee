# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- exec after page loading ---
$ ->
	$(this).whenExist "body[id^='body_courses_']", ->

		$("#courses_index_subscriptions").on 'ajax:success', (event, response, status) ->
			$("#courses_index_subscriptions").html(response)

		$("#course_poster").change ->
			if this.files && this.files[0]
				reader = new FileReader();
				reader.onload = (e) ->
					$("#course_preview_poster").hide().fadeIn(300).attr 'src', e.target.result
				reader.readAsDataURL(this.files[0]);

		$('#new_course').on 'ajax:aborted:file', (event, elements) ->
			request_with_poster(event, elements)
			false

		$("form[id^='edit_course_']").on 'ajax:aborted:file', (event, elements) ->
			request_with_poster(event, elements, 'PATCH')
			false

		if $('#course_theme_color').length
			color = $('#course_theme_color').attr 'content'
			$('.background_coloured_element').attr 'style', "background-color: #{color} !important"
			$('.text_coloured_element').attr 'style', "color: #{color} !important"


# --- send form with file (poster) ---
request_with_poster = (event, elements, type = 'POST') ->
	Form = new FormData(event.target)
	$.ajax
		url: event.currentTarget.action
		type: type
		data: Form
		contentType: false
		processData: false
		success: (response) ->
			$(event.target).trigger 'ajax:success', response

		error: (response) ->
			$(event.target).trigger 'ajax:error', response

	false
