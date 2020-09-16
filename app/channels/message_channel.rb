class MessageChannel < ApplicationCable::Channel

  # チャンネル接続時に呼ばれる
  def subscribed
    stream_from 'message_channel'
  end

  def send_message(data)
    @message = Message.create!(
      chat_group_id: data['chat_group_id'],
      body: data['message']
    )
    
    ActionCable.server.broadcast 'message_channel', message: @message
  end

  # チャンネル切断時に呼ばれる
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
