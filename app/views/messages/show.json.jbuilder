json.messages @messages do |message|
  json.user_icon   message.user.try(:profile).try(:[], 'image_72')
  json.user_name   message.username
  json.date        I18n.l(Time.at(message.ts.to_i))
  json.content     message.text
  json.attachments message.attachments
end
