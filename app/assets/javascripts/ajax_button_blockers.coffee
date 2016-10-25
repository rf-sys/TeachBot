$('#login_form').bind('ajaxSend', ->
  $('#login_btn').attr 'disabled', true
).bind 'ajaxComplete', ->
  $('#login_btn').attr 'disabled', false

$('#new_user').bind('ajaxSend', ->
  $('#create_user_btn').attr 'disabled', true
).bind 'ajaxComplete', ->
  $('#create_user_btn').attr 'disabled', false

$('#edit_user_form').bind('ajaxSend', ->
  $('#edit_user_btn').attr 'disabled', true
).bind 'ajaxComplete', ->
  $('#edit_user_btn').attr 'disabled', false

