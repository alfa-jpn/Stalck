module MessagesHelper

  # Decode message
  # @param [String] message
  # @return [String] replaced message
  def decode_message(message)
    if message.present?
      message = replace_links(message)
      message = replace_lines(message)
      replace_emojis(message)
    else
      nil
    end
  end

  private

  # Replace message link.
  # @param [String] message
  # @return [String] replaced message
  def replace_links(message)
    message.gsub(/<(.+?)>/) do
      link, label = $1.split('|')
      case link[0..1]
        when '@U'
          "@#{User.find_by_id(link[1..-1]).name}"
        when '#C'
          "##{Channel.find_by_id(link[1..-1]).name}"
        else
          "<a href='#{link}'>#{label.present? ? label : link}</a>"
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

  # Replace emoji.
  # @param [String] message
  # @return [String] replaced message
  def replace_emojis(message)
    message.gsub(/:([a-z0-9_-]+?):/) do
      case
        when emoji = CustomEmoji.find_by_name($1)
          "<img src='#{emoji}'>"
        when emoji = Emoji.find_by_alias($1)
          "<img src='#{image_path("emoji/#{emoji.image_filename}")}'>"
        else
         ":#{$1}:"
      end
    end

  end
end
