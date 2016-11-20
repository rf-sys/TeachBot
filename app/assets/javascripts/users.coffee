class EditProfile

	@update_profile_info: (e, response) ->
		$('#user_username').text response.data.username
		$('#header_user_link').text response.data.username
		$('#user_email').text response.data.email

		$('#user_avatar').attr 'src', response.data.avatar + '?' + Math.random() if response.data.avatar

	@file_prepare: (event, elements) ->
		Form = new FormData
		Form.append 'user[username]', $("input[name='user[username]']").val().trim()
		Form.append 'user[email]', $("input[name='user[email]']").val().trim()
		Form.append 'user[avatar]', elements[0].files[0]

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
	$('#edit_user_form').on('ajax:success', (e, response) ->
		EditProfile.update_profile_info(e, response)
	).on('ajax:aborted:file', (event, elements) ->
		EditProfile.file_prepare(event, elements)
		false
	)
	$('#new_user').bind 'ajax:error', ->
		grecaptcha.reset()




