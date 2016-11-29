update_header = (e, response) ->
	$('#header_user_link').text response.data.username

request_with_avatar = (event, elements) ->
	Form = new FormData(document.getElementById('edit_user_form'))
	$.ajax
		url: event.currentTarget.action
		type: 'PATCH'
		data: Form
		contentType: false
		processData: false
		success: (response) ->
			$('#edit_user_form').trigger 'ajax:success', response

		error: (response) ->
			$('#edit_user_form').trigger 'ajax:error', response

	false

$(document).on 'turbolinks:load', ->
	$("#user_avatar").change ->
		if this.files && this.files[0]
			reader = new FileReader();
			reader.onload = (e) ->
				$("#uploaded_avatar").attr 'src', e.target.result
			reader.readAsDataURL(this.files[0]);

	$('#edit_user_form').on('ajax:success', (e, response) ->
		update_header(e, response)
	).on('ajax:aborted:file', (event, elements) ->
		request_with_avatar(event, elements)
		false
	)
	$('#new_user').bind 'ajax:error', ->
		grecaptcha.reset()


$(document).bind 'googleMaps', ->
	if $("#user_profile_attributes_location").length
		new google.maps.places.Autocomplete document.getElementById 'user_profile_attributes_location'
