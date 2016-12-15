class MessageSearcher
  include Concerns::Models::SlackAdapter

  column :total
  column :pagination
  column :paging
  column :matches
  column :posts

  # Messages.
  # @return [MessageSearchers::Message] message
  def messages
    @messages ||= matches.map { |m| MessageSearchers::Message.new(m) }
  end

  api_singleton_method :search, 'search.messages', :messages, collection: false
end
