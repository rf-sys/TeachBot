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

  $(this).whenExist "#body_lessons_show", ->
    if typeof DISQUS == 'undefined'
      do ->
        dsq = document.createElement('script')
        dsq.type = 'text/javascript'
        dsq.async = true
        dsq.src = 'https://teachbot.disqus.com/embed.js'
        (document.getElementsByTagName('head')[0] or document.getElementsByTagName('body')[0]).appendChild dsq
    else
      DISQUS.reset
        reload: true
        config: ->
          @page.url = $("meta[name='lesson_url']").attr("content");
          @page.identifier = $("meta[name='lesson_id']").attr("content");

