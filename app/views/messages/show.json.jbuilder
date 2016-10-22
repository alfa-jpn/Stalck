json.messages @messages do |message|
  json.user_icon message.user.try(:profile).try(:[], 'image_72')
  json.user_name message.username
  json.date      I18n.l(Time.at(message.ts.to_i))
  json.link      message.permalink
  json.text      decode_message(message.text)

  json.channel do
    json.id   message.channel['id']
    json.name "##{message.channel['name']}"
  end

  json.attachments message.attachments do |attachment|
    json.title  attachment['title']
    json.author attachment['author']
    json.text   decode_message(attachment['text'])
    json.image  attachment['image_url']
    json.color  attachment['color'] || 'ddd'

    json.fields attachment['fields'] do |field|
      json.title field['title']
      json.text  decode_message(field['value'])
      json.type  field['short'] ? 'shortly' : 'normal'
    end
  end
end
