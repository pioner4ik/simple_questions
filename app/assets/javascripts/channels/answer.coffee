App.answer = App.cable.subscriptions.create channel: "AnswerChannel", 
  connected: ->
    @perform 'follow', id: gon.question_id

  disconnected: ->
    @perform 'unfollow'

  received: (data) ->
    ###alert data###
    $('.answers').append(JST["templates/answer"]($.parseJSON(data)))
