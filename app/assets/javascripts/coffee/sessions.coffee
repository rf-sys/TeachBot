$ ->
  $(this).whenExist "#body_sessions_new", ->
    $('#login_form').submit ->
      sessionStorage.clear()
    $('#facebook_oauth_btn').click ->
      sessionStorage.clear()
    $('#github_oauth_btn').click ->
      sessionStorage.clear()