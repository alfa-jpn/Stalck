module MessagesHelper

  # Decode message
  # @param [String] message
  # @return [String] replaced message
  def decode_message(message)
    if message.present?
      message = replace_links_and_emojis(message)
      replace_lines(message)
    else
      nil
    end
  end

  private

  # Replace message link.
  # @param [String] message
  # @return [String] replaced message
  def replace_links_and_emojis(message)
    message.gsub(/<(.+?)>|:([a-z0-9_-]+?):/) do |match|
      case match[0]
        when '<'
          replace_link($1)
        when ':'
          replace_emoji($2)
      end
    end
  end

  # Replace break line code.
  # @param [String] message
  # @return [String] replaced message
  def replace_lines(message)
    message.gsub(/\r?\n/) do
      '<br>'
    end
  end

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
            "<a href='#{link}'>#{label.present? ? label : link}</a>"
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
