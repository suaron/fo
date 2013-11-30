# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = () ->
  $("#add_new_item").on "click", (e) ->
    time = new Date().getTime()
    regexp = new RegExp("object_id", "g")
    $($(this).data("fields").replace(regexp, time)).prependTo ".items-panel"
    e.preventDefault()

$(document).ready(ready)
