ready = ->

  $('.fa-caret-up, .fa-caret-down').bind 'ajax:success', (e, data, status,xhr) ->
    model_type = $.parseJSON(xhr.responseText)
    model_name = model_type.vote.votable_type.toLowerCase()
    model_id = model_type.vote.votable_id
    $('#'+ model_name + "-" + model_id).find("h1").html(model_type.rating)
    $('#'+ model_name + "-" + model_id).find(".re-vote").show()

  .bind 'ajax:error', (e, xhr, status, error) ->
    $('.error-messages').html(xhr.responseText)

  $('.re-vote').bind 'ajax:success', (e, data, status,xhr) ->
    model_type = $.parseJSON(xhr.responseText)
    model_name = model_type.vote.votable_type.toLowerCase()
    model_id = model_type.vote.votable_id
    $('#'+ model_name + "-" + model_id).find("h1").html(model_type.rating)
    $('#'+ model_name + "-" + model_id).find(".re-vote").hide()

###
  Cначала попробовал что-то вроде этого но почему то не идет
  решил оставить вариант выше
  $('.fa-caret-up, .fa-caret-down, .re-vote').bind 'ajax:success', (e, data, status,xhr) ->
    model_type = $.parseJSON(xhr.responseText)
    model_name = model_type.vote.votable_type.toLowerCase()
    model_id = model_type.vote.votable_id
    $('#'+ model_name + "-" + model_id).find("h1").html(model_type.rating)
    if $(this).click is ('.fa-caret-up, .fa-caret-down')
      $('#'+ model_name + "-" + model_id).find(".re-vote").show()
    else if $(this).click is ('.re-vote')
      $('#'+ model_name + "-" + model_id).find(".re-vote").hide()
###

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)