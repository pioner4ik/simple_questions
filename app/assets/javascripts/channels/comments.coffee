App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    @perform 'follow', id: gon.question_id

  disconnected: ->
    
  received: (data) ->
    comment = $.parseJSON(data)
    commentTable = $('.comments[commentable_id="' + comment.commentable_id + '"][commentable_type="' + comment.commentable_type + '"]')
    commentTable.prepend(JST["templates/comment"]({comment: comment}))
