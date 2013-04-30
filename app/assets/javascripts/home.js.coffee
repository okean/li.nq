# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

show_ajax_message = (msg, type) ->
    $(".flash_message").html "<div class='alert alert-#{type}'>#{msg}</div>"
    $(".alert-#{type}").delay(5000).slideUp 'slow'

$(document).ajaxComplete (event, request) ->
    msg = request.getResponseHeader("X-Message")
    type = request.getResponseHeader("X-Message-Type")
    if (msg != "error")
        show_ajax_message msg, type