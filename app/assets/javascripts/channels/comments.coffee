App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    @perform 'follow', id: gon.question_id

  disconnected: ->
    @perform 'unfollow'
    
  received: (data) ->
    comment_as_json = $.parseJSON(data)
    commentTable = $('.comments[commentable_id="' + comment_as_json.comment.commentable_id + '"][commentable_type="' + comment_as_json.comment.commentable_type + '"]')
    commentTable.prepend(JST["templates/comment"](comment_as_json))
