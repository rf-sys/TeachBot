# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $(this).whenExist "form.new_lesson, form.edit_lesson", ->

    autosize($('#lesson_description'))

    $('form.new_lesson, form.edit_lesson')
      .on 'ajax:before', ->
        html = $('#lesson_html_content').html()
        $('#lesson_content').val(html)

    $(document).on 'turbolinks:before-visit', ->
      $("div.wysihtml5-sandbox, input[name='_wysihtml5_mode']").remove()
      $("body").removeClass("wysihtml5-supported")