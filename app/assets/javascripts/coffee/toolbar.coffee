$ ->
  $(this).whenExist "form.new_lesson, form.edit_lesson", ->
    editor = new wysihtml5.Editor('lesson_html_content', {
      toolbar: 'wysihtml_toolbar',
      parserRules:
        classes:
          "wysiwyg-text-align-center": 1
          "wysiwyg-text-align-left": 1
          "wysiwyg-text-align-right": 1
          "p": 1
          "blockquote": 1
        tags:
          i: 1
          h1:
            add_class:
              align: "align_text"
          h2:
            add_class:
              align: "align_text"
          b: 1
          p: 1
          img:
            check_attributes:
              width: "numbers"
              alt: "alt"
              src: "url"
              height: "numbers"
            add_class:
              align: "align_img"
          div: 1
          ul: 1
          ol: 1
          li: 1
          code: 1,
          blockquote: 1
    });

    wysihtml5.commands.customCode =
      options: {
        nodeName: "code"
        toggle: true
      }
      exec: (composer, command) ->
        wysihtml5.commands.formatInline.exec composer, command, @options
        return
      state: (composer, command) ->
        wysihtml5.commands.formatInline.state composer, command, @options

    wysihtml5.commands.blockquote =
      options: {
        nodeName: "blockquote"
        className: "blockquote"
        toggle: true
      }
      exec: (composer, command) ->
        wysihtml5.commands.formatInline.exec composer, command, @options
        return
      state: (composer, command) ->
        wysihtml5.commands.formatInline.state composer, command, @options