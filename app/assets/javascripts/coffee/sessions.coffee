$ ->
  $(this).whenExist "#body_sessions_new", ->
    $('#login_form').submit ->
      sessionStorage.clear();
      console.log 'cleared'