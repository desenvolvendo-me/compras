if @message
  json.id             @message.id
  json.body           @message.body
  json.sender_name    @message.sender.authenticable.user.name_and_profile
  json.created_at     @message.created_at.strftime("%I:%M %p")
end

json.url auction_conversation_message_url(@conversation, @message)
