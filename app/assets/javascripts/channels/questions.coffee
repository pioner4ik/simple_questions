App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    @perform 'follow'

  disconnected: ->
    @perform 'unfollow'

  received: (data) ->
    $('#questions').prepend(JST["templates/question"]($.parseJSON(data)))
