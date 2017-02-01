# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(this).whenExist "#body_lessons_new", ->
    editor = new wysihtml5.Editor('lesson_description', {
      toolbar: 'toolbar',
      parserRules: {
        tags: {
          i: {},
          h1: {},
          img: {
            check_attributes: {
              width: "numbers",
              alt: "alt",
              src: "url",
              height: "numbers",
            },
            add_class: {
              align: "align_img"
            }
          }
        },
      }
    });
    $('#new_lesson').on 'ajax:success', ->
      $("iframe.wysihtml5-sandbox, input[name='_wysihtml5_mode']").remove();
      $("body").removeClass("wysihtml5-supported");