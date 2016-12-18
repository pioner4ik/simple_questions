App.answer = App.cable.subscriptions.create "AnswerChannel",
  connected: ->
    @perform 'follow'

  disconnected: ->

  received: (data) ->
    $('.answers').append(JST["templates/answer"]({ answer: ($.parseJSON(data)) }))
