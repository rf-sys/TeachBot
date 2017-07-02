$(document).click (event) ->
  if !$(event.target).closest('#global_search_result_panel').length
    if $('#global_search_result_panel').is(':visible')
      $(document).trigger('global_search_result_panel:hide')