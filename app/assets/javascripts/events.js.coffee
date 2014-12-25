$(document).on "ready page:load", ->
  $('#event_price_currency').change ->
    $('#price_symbol').html($(this).find(":selected").data('symbol'))
