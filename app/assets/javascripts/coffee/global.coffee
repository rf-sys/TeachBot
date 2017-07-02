window.getUrlParameter = (name) ->
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
  regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
  results = regex.exec(location.search)
  if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))


$(document).on 'turbolinks:load', ->
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover({
    trigger: 'focus'
  })