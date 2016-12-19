App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    @perform 'follow'

  disconnected: ->
    
  received: (data) ->
    $('#questions').prepend(JST["templates/question"]($.parseJSON(data)))
