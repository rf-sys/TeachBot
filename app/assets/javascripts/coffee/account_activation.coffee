$ ->
  $(this).whenExist '#body_account_activations_new', ->
    $('#account_activation_email_form').on 'ajax:success', ->
      $(document).trigger('RMB:success', "Activation email has been sent");