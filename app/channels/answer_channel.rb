class AnswerChannel < ApplicationCable::Channel
  def follow
    stream_from "answers"
  end
end
