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

  api_singleton_method :all,  'channels.list', :channels
  api_singleton_method :find, 'channels.info', :channel, collection: false

  class << self
    # Find channel by id。
    # @return [User, Nil] channel
    def find_by_id(id)
      dictionary[id] || find_with_cache(id)
    end

    # Channel dictionary.
    # @return [Hash] dictionary.
    def find_with_cache(id)
      Rails.cache.fetch("Channel.Cache.#{id}", expires_in: 5.minutes) do
        begin
          find(channel: id)
        rescue RuntimeError => e
          if e.message == 'channel_not_found'
            nil
          else
            raise
          end
        end
      end
    end

    private
    # Channel dictionary.
    # @return [Hash] dictionary.
    def dictionary
      Rails.cache.fetch('Channel.Dictionary', expires_in: 5.minutes) do
        all.map { |user| [user.id, user] }.to_h
      end
    end
  end
end
