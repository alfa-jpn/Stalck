class CustomEmoji
  include Concerns::Models::SlackAdapter

  column :emoji

  api_singleton_method :all, 'emoji.list', nil, collection: false

  class << self
    # Find emoji by name.
    # @return [String, Nil] name
    def find_by_name(name)
      emoji = dictionary[name]
      if /^alias:(?<to>.+)$/ =~ emoji
        dictionary[to]
      else
        emoji
      end
    end

    private
    # User dictionary.
    # @return [Hash] dictionary.
    def dictionary
      Rails.cache.fetch('Emoji.dictionary', expires_in: 5.minutes) do
        all.emoji
      end
    end
  end
end
