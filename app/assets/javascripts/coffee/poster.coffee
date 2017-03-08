# cropper wrapper
class PosterCropper
  constructor: (@image) ->
    @setPreview()
    @cropper = new Cropper @image,
      aspectRatio: 22 / 8
      minContainerHeight: 300

  setPreview: ->
    attr = $('#course_poster_image').attr 'src'
    $('#course_preview_poster').attr('src', attr).show() if attr

  update: (url) ->
    @cropper.replace url

  reset: ->
    @cropper.reset()

  destroy: ->
    @cropper.destroy()
    @resetPosterFile()


  resetPosterFile: ->
    $("#course_poster").val ''

  upload: (e) ->
    $btn = $('#upload_poster_btn')
    @cropper.getCroppedCanvas().toBlob (blob) ->
      formData = new FormData()
      formData.append('course[poster]', blob)

      $.ajax e.currentTarget.action,
        method: "PATCH"
        data: formData
        processData: false
        contentType: false,
        beforeSend: ->
          $btn.addClass('disabled').val 'Uploading...'

        complete: ->
          $btn.removeClass('disabled').val 'Upload poster'

        success: (response) ->
          $('#course_poster_image').attr('src', response.url).show()
          $('#edit_poster_modal').modal('hide')

        error: (response) ->
          $(document).trigger 'ajax:error', response

      false

$ ->
  $(this).whenExist "body[id^='body_courses_']", ->

    image = document.getElementById 'course_preview_poster'

    poster_cropper = undefined

    $('#edit_poster_modal')
      .on 'shown.bs.modal', ->
        poster_cropper = new PosterCropper image
      .on 'hidden.bs.modal', ->
        poster_cropper.destroy()

    $("#course_poster").change ->
      if this.files && this.files[0]
        reader = new FileReader();
        reader.onload = (e) ->
          $("#course_preview_poster").attr 'src', e.target.result
          poster_cropper.reset()
          poster_cropper.update(e.target.result)
          console.log '123'
        reader.readAsDataURL(this.files[0]);

    $('#edit_course_poster').submit (e) ->
      poster_cropper.upload(e)
      false
