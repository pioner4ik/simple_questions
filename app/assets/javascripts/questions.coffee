ready = ->
  $('.edit-question-link').click (e) -> 
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  $('.fa-caret-up').bind 'ajax:success', (e, data, status,xhr) ->
    $('.vote-total h1').html(xhr.responseText)
    
  $('.fa-caret-down').bind 'ajax:success', (e, data, status,xhr) ->
    $('.vote-total h1').html(xhr.responseText)  
 
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)