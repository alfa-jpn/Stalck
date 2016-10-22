module MessagesHelper

  # Decode message
  # @param [String] message
  # @return [String] replaced message
  def decode_message(message)
    if message.present?
      replace_links(message)
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
end
