class AnswerChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['id']}-answers"
  end

  def unfollow
    stop_all_streams
  end
end
