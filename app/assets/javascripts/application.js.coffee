#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-sprockets
#= require bootstrap
#= require bootstrap-datepicker
#= require_tree .

$(document).on "ready page:load", ->
  $('.datepicker').datepicker({
    startView: 2
  })
