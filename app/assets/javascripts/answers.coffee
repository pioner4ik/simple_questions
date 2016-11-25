ready = ->
  $('.edit-answer-link').click (e) -> 
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.make-best-button').click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    if $('#best-answer').is(':empty')
      $('#best-answer').prepend($('#answer-' + answer_id))
    else if $('#best-answer').is('*')
      $('#best-answer').children().prependTo($('.answers'))
      $('#best-answer').children().replaceWith($('#answer-' + answer_id))

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)