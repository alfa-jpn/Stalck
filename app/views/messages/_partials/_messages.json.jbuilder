json.messages messages do |message|
  json.id        Digest::SHA256.hexdigest(message.to_json)
  json.user_icon message.user.try(:profile).try(:[], 'image_72') || emoji_path(message.username) || ''
  json.user_name message.username
  json.date      I18n.l(Time.zone.at(message.ts.to_i))
  json.link      message.permalink
  json.text      decode_message(message.text)
  json.timestamp message.ts

  json.channel do
    json.id   message.channel['id']
    json.name "##{message.channel['name']}"
  end

  json.attachments message.attachments do |attachment|
    json.title       attachment['title']
    json.author_icon attachment['author_icon'] || ''
    json.author_name attachment['author_name']
    json.text        decode_message(attachment['text'])
    json.image       attachment['image_url']
    json.color       attachment['color'] || 'ddd'

    json.fields attachment['fields'] do |field|
      json.title field['title']
      json.text  decode_message(field['value'])
      json.type  field['short'] ? 'shortly' : 'normal'
    end
  end
end
