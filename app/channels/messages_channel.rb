class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'messages_channel'
  end

  def receive(data)
    ActionCable.server.broadcast('chat_channel', data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
