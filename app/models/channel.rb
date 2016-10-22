class Channel
  include Concerns::Models::SlackAdapter

  column :id
  column :name
  column :created
  column :creator
  column :is_archived
  column :is_member
  column :num_members
  column :topic
  column :purpose

  api_singleton_method :all, 'channels.list', :channels

  class << self
    # Find channel by id。
    # @return [User, Nil] channel
    def find_by_id(id)
      dictionary[id]
    end

    private
    # Channel dictionary.
    # @return [Hash] dictionary.
    def dictionary
      Rails.cache.fetch('Channel.dictionary', expires_in: 5.minutes) do
        all.map { |user| [user.id, user] }.to_h
      end
    end
  end
end
