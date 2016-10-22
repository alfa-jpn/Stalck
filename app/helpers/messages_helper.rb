module MessagesHelper

  # Decode message
  # @param [String] message
  # @return [String] replaced message
  def decode_message(message)
    if message.present?
      message.gsub(/```([\s\S]+?)```\r?\n|<(.+?)>|:([a-z0-9_-]+?):|\r?\n/) do |match|
        case match[0]
          when '`'
            "<pre>#{$1}</pre>"
          when '<'
            replace_link($2)
          when ':'
            replace_emoji($3)
          else
            '<br>'
        end
      end
    else
      nil
    end
  end

  private

  # Replace message link.
  # @param [String] text
  # @return [String] replaced link
  def replace_link(text)
    link, label = text.split('|')
    case link[0..1]
      when '@U'
        "@#{User.find_by_id(link[1..-1]).name}"
      when '#C'
        "##{Channel.find_by_id(link[1..-1]).name}"
      else
        case link[0]
          when '!'
            "@#{link[1..-1]}"
          else
            "<a href='#{link}' target='_blank'>#{label.present? ? label : link}</a>"
        end
    end
  end

  # Replace emoji.
  # @param [String] text
  # @return [String] replaced emoji
  def replace_emoji(text)
    case
      when emoji = CustomEmoji.find_by_name(text)
        "<img src='#{emoji}'>"
      when emoji = Emoji.find_by_alias(text)
        "<img src='#{image_path("emoji/#{emoji.image_filename}")}'>"
      else
       ":#{text}:"
    end
  end
end
