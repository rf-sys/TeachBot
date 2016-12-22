$.fn.whenExist = (body_id, callback) ->
	$(this).on 'turbolinks:load', ->
		callback() if $(body_id).length

$.fn.turbolinks_load = (callback) ->
	$(document).on 'turbolinks:load', -> callback()
