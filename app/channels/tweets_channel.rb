class TweetsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'tweets'
  end
end
