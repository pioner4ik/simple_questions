ready = ->
  $('.show-comments').click (e) -> 
    e.preventDefault()
    id = $(this).data('commentableId')
    type = $(this).data('commentableType')
    $('#comments-'+ type + '-' + id).show()
    $('#'+ type + '-' + id).find(".hide-comments").show()
    $('#'+ type + '-' + id).find(".show-comments").hide()

  $('.hide-comments').click (e) -> 
    e.preventDefault()
    id = $(this).data('commentableId')
    type = $(this).data('commentableType')
    $('#comments-'+ type + '-' + id).hide()
    $('#'+ type + '-' + id).find(".show-comments").show()
    $('#'+ type + '-' + id).find(".hide-comments").hide()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)