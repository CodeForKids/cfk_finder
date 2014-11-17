window.Toast = {}
toastQueue = []
showing = false

Toast.processToast = () ->
  if toastQueue.length > 0
    toast = toastQueue.shift()
    $("#toasts").find(':first-child').remove()
    if $(toast).data("toast-type") == "error"
      Toast.toastError $(toast).text()
    else
      Toast.toastMessage $(toast).text()

Toast.toastMessage = (message) ->
  if !showing
    $('#toast').text message
    $('#toast').addClass 'active'
    showing = true
    setTimeout(timeout, 5000)
  else
    toastQueue.push("<div data-toast-type='notice'>#{message}</div>")

Toast.toastError = (message) ->
  if !showing
    $('#toast').text(message)
    $('#toast').addClass 'error'
    $('#toast').addClass 'active'
    showing = true
    setTimeout(timeout, 5000)
  else
    toastQueue.push("<div data-toast-type='error'>#{message}</div>")

timeout = () ->
  $('#toast').removeClass 'active'
  $('#toast').removeClass 'error'
  setTimeout( () =>
    showing = false
    Toast.processToast()
  , 200);

$(document).on "ready page:load", ->
  toastQueue = $.makeArray $('#toasts').children()
  Toast.processToast()
