# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- exec after page loading ---
$ ->
  $(this).whenExist "body[id^='body_courses_']", ->
    $("#courses_index_subscriptions").on 'ajax:success', (event, response, status) ->
      $("#courses_index_subscriptions").html(response)

    $('#course_tags').selectize
      delimiter: ','
      persist: false,
      maxItems: 7,
      create: (input) ->
        {
          value: input
          text: input
        }

  $(this).whenExist "#course_theme_color", ->
    color = $('#course_theme_color').attr 'content'
    $('.background_coloured_element').attr 'style', "background-color: #{color} !important"
    $('.text_coloured_element').attr 'style', "color: #{color} !important"


