#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-datepicker
#= require bootstrap-sprockets
#= require bootstrap
#= require_tree .

$(document).on "ready page:load", ->
  $('.datepicker').datepicker({
    startView: 2
  })
