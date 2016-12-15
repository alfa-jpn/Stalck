class Message
  include Concerns::Models::SlackAdapter

  api_singleton_method :create, 'chat.postMessage', :message, collection: false
end
